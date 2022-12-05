import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'beep_file.dart';
import 'beep_player_method_channel.dart';

abstract class BeepPlayerPlatform extends PlatformInterface {
  /// Constructs a BeepPlayerPlatform.
  BeepPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BeepPlayerPlatform _instance = BeepPlayerMethodChannel();

  /// The default instance of [BeepPlayerPlatform] to use.
  ///
  /// Defaults to [BeepPlayerMethodChannel].
  static BeepPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BeepPlayerPlatform] when
  /// they register themselves.
  static set instance(BeepPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> load(BeepFile file) {
    throw UnimplementedError('load() has not been implemented.');
  }

  Future<void> play(BeepFile file) {
    throw UnimplementedError('play() has not been implemented.');
  }

  Future<void> unload(BeepFile file) {
    throw UnimplementedError('unload() has not been implemented.');
  }
}
