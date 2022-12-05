import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'beep_file.dart';
import 'beep_player_platform_interface.dart';

/// An implementation of [BeepPlayerPlatform] that uses method channels.
class BeepPlayerMethodChannel extends BeepPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel channel = const MethodChannel('app.iandis.beep_player');

  @override
  Future<void> load(BeepFile file) {
    return channel.invokeMethod<void>(
      'load',
      file.toFullPath,
    );
  }

  @override
  Future<void> play(BeepFile file) {
    return channel.invokeMethod<void>(
      'play',
      file.toFullPath,
    );
  }

  @override
  Future<void> unload(BeepFile file) {
    return channel.invokeMethod<void>(
      'unload',
      file.toFullPath,
    );
  }
}
