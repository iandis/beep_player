package app.iandis.beep_player

import android.content.Context
import android.content.res.AssetManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** BeepPlayerPlugin */
class BeepPlayerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var _channel: MethodChannel

    private lateinit var _beepPlayer: BeepPlayer

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        _beepPlayer = BeepPlayer(
            flutterPluginBinding.applicationContext.assets,
            flutterPluginBinding.flutterAssets,
        )
        _channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "app.iandis.beep_player",
        )
        _channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val filePath: String? = call.arguments<String>()
        if (filePath == null) {
            result.error(
                "INVALID_ARGUMENT",
                "filePath is null",
                null,
            )
            return
        }
        when (call.method) {
            "load" -> {
                _beepPlayer.load(filePath)
                result.success(true)
            }
            "play" -> {
                _beepPlayer.play(filePath)
                result.success(true)
            }
            "unload" -> {
                _beepPlayer.unload(filePath)
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        _channel.setMethodCallHandler(null)
        _beepPlayer.dispose()
    }
}
