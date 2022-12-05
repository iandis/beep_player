import 'beep_file.dart';
import 'beep_player_platform_interface.dart';

/// A player for short audio asset files, such as beeps.
/// This should not be used for long audio files.
///
/// On Android, this uses the `SoundPool` API, with audio attributes set to
/// `AudioAttributes.USAGE_ASSISTANCE_SONIFICATION` and
/// `AudioAttributes.CONTENT_TYPE_SONIFICATION` with max streams of 1.
///
/// On iOS, this uses the `AVAudioPlayer` API, with audio category set to
/// `AVAudioSessionCategoryAmbient`.
class BeepPlayer {
  /// Loads an asset audio file into memory.
  static Future<void> load(BeepFile file) {
    return BeepPlayerPlatform.instance.load(file);
  }

  /// Plays a loaded asset audio file.
  /// Before calling this method, you must call [load] to load the audio file.
  static Future<void> play(BeepFile file) {
    return BeepPlayerPlatform.instance.play(file);
  }

  /// Unloads an asset audio file from memory.
  /// Releases the memory used by the audio file.
  static Future<void> unload(BeepFile file) {
    return BeepPlayerPlatform.instance.unload(file);
  }
}
