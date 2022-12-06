package app.iandis.beep_player

import android.content.res.AssetFileDescriptor
import android.content.res.AssetManager
import android.media.AudioAttributes
import android.media.SoundPool
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class BeepPlayer(
    private val _assetManager: AssetManager,
    private val _flutterAssets: FlutterAssets
) : CoroutineScope by CoroutineScope(Dispatchers.IO) {
    private val _audioAttributes: AudioAttributes = AudioAttributes.Builder()
        .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
        .build()
    private val _soundPool: SoundPool = SoundPool.Builder()
        .setAudioAttributes(_audioAttributes)
        .setMaxStreams(1)
        .build()
    private var _soundIds: MutableMap<String, Int> = mutableMapOf()
    private var _isDisposed: Boolean = false

    init {
        if (BuildConfig.DEBUG) {
            _soundPool.setOnLoadCompleteListener { _, soundId: Int, status: Int ->
                if (status != 0) {
                    Log.d(this::class.java.simpleName, "Failed to load sound id: $soundId")
                    return@setOnLoadCompleteListener
                }
                Log.d(this::class.java.simpleName, "Successfully loaded sound id: $soundId")
            }
        }
    }

    fun load(filePath: String) {
        if (_isDisposed) return
        _load(filePath)
    }

    private fun _load(filePath: String) {
        launch {
            try {
                val assetFullPath: String = _flutterAssets.getAssetFilePathByName(filePath)
                val assetFile: AssetFileDescriptor = _assetManager.openFd(assetFullPath)
                val newSoundId: Int = _soundPool.load(assetFile, 1)
                launch(Dispatchers.Main) {
                    _soundIds[filePath] = newSoundId
                }
            } catch (e: Throwable) {
                Log.d(this::class.java.simpleName, "Failed to load sound: $filePath", e)
            }

        }
    }

    fun play(filePath: String) {
        if (_isDisposed) return
        _maybePlay(filePath)
    }

    private fun _maybePlay(filePath: String) {
        val soundId: Int? = _soundIds[filePath]
        if (soundId == null) {
            Log.d(this::class.java.simpleName, "$filePath has not been loaded")
        } else {
            _play(soundId)
        }
    }

    private fun _play(soundId: Int) {
        launch {
            Log.d(this::class.java.simpleName, "Playing sound id: $soundId")
            val result: Int = _soundPool.play(
                soundId,
                1.0f,
                1.0f,
                1,
                0,
                1.0f
            )
            if (result == 0) {
                Log.d(this::class.java.simpleName, "Failed to play sound id: $soundId")
                launch(Dispatchers.Main) {
                    _soundIds = _soundIds.filterValues { it != soundId }.toMutableMap()
                }
            }
        }
    }

    fun unload(filePath: String) {
        if (_isDisposed) return
        val soundId: Int = _soundIds[filePath] ?: return
        Log.d(this::class.java.simpleName, "Unloading sound id: $soundId")
        launch {
            _soundPool.unload(soundId)
            launch(Dispatchers.Main) {
                _soundIds.remove(filePath)
            }
        }
    }

    fun dispose() {
        if (_isDisposed) return
        _isDisposed = true
        _soundPool.release()
        _soundIds = mutableMapOf()
    }
}