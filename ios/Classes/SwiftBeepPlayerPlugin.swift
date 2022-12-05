import Flutter
import UIKit

public class SwiftBeepPlayerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "app.iandis.beep_player", binaryMessenger: registrar.messenger())
        let beepPlayer: BeepPlayer = BeepPlayer(registrar)
        let instance: SwiftBeepPlayerPlugin = SwiftBeepPlayerPlugin(beepPlayer)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    init(_ beepPlayer: BeepPlayer) {
        _beepPlayer = beepPlayer
    }
    
    private let _beepPlayer: BeepPlayer
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let filePath: String = call.arguments as? String else {
            result(FlutterError(
                code: "INVALID_ARGUMENT",
                message: "filePath is null",
                details: nil
            ))
            return
        }
        _beepPlayer.initAudioSession()
        
        switch call.method {
        case "load":
            _beepPlayer.load(filePath)
            result(true)
        case "play":
            _beepPlayer.play(filePath)
            result(true)
        case "unload":
            _beepPlayer.unload(filePath)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
