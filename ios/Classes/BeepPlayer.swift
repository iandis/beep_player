//
//  BeepPlayer.swift
//  beep_player
//
//  Created by Iandi Santulus on 05/12/22.
//

import Foundation
import AVFoundation
import Flutter

class BeepPlayer : NSObject, AVAudioPlayerDelegate {
    
    init(_ registrar: FlutterPluginRegistrar) {
        _registrar = registrar
    }
    
    private let _registrar: FlutterPluginRegistrar
    private let _audioPlayerDispatcher: DispatchQueue = DispatchQueue(
        label: "app.iandis.beep_player.BeepPlayer:audioPlayerDispatcher",
        qos: .background
    )
    private let _mainDispatcher: DispatchQueue = DispatchQueue.main
    
    private var _audioPlayers: [String:AVAudioPlayer] = [:]
    private var _activeAudioPlayer: AVAudioPlayer?
    private var _isAudioSessionInitialized: Bool = false
    
    func initAudioSession() {
        if _isAudioSessionInitialized {
            return
        }
        _isAudioSessionInitialized = true
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let e {
#if DEBUG
            print(
                "An error occurred when initializing AVAudioSession\n" +
                e.localizedDescription
            )
#endif
        }
    }
    
    func load(_ filePath: String) {
        _load(filePath)
    }
    
    private func _load(_ filePath: String) {
        _audioPlayerDispatcher.async { [weak self] in
            guard let self: BeepPlayer = self else {
                return
            }
            let assetKey: String = self._registrar.lookupKey(forAsset: filePath)
            guard let assetURL: URL = Bundle.main.url(forResource: assetKey, withExtension: nil) else {
#if DEBUG
                print("Asset file not found: \(filePath)")
#endif
                return
            }
            guard let audioPlayer: AVAudioPlayer = try? AVAudioPlayer(contentsOf: assetURL) else {
#if DEBUG
                print("Failed to initialize AVAudioPlayer for \(filePath)")
#endif
                return
            }
            let isSuccess: Bool = audioPlayer.prepareToPlay()
            if !isSuccess {
#if DEBUG
                print("Failed to prepare AVAudioPlayer to play \(filePath)")
#endif
                return
            }
#if DEBUG
            print("Successfully prepared AVAudioPlayer to play \(filePath)")
#endif
            audioPlayer.delegate = self
            self._mainDispatcher.sync {
                self._audioPlayers[filePath] = audioPlayer
            }
        }
    }
    
    func play(_ filePath: String) {
        guard let loadedAudioPlayer: AVAudioPlayer = _audioPlayers[filePath] else {
#if DEBUG
            print("\(filePath) has not been loaded")
#endif
            return
        }
        if let activeAudioPlayer: AVAudioPlayer = _activeAudioPlayer {
            activeAudioPlayer.pause()
            _activeAudioPlayer = nil
        }
        _activeAudioPlayer = loadedAudioPlayer
        _audioPlayerDispatcher.async { [weak self] in
            loadedAudioPlayer.currentTime = 0.0
            let isSuccess: Bool = loadedAudioPlayer.play()
            if !isSuccess {
#if DEBUG
                print("Failed to play \(filePath)")
#endif
                guard let self: BeepPlayer = self else {
                    return
                }
                self._mainDispatcher.sync {
                    self._activeAudioPlayer = nil
                }
                return
            }
#if DEBUG
            print("Started playing \(filePath)")
#endif
        }
    }
    
    func unload(_ filePath: String) {
        guard let loadedAudioPlayer: AVAudioPlayer = _audioPlayers[filePath] else {
#if DEBUG
            print("\(filePath) has not been loaded")
#endif
            return
        }
        
#if DEBUG
        print("Unloading \(filePath)")
#endif
        loadedAudioPlayer.stop()
        if _activeAudioPlayer == loadedAudioPlayer {
            _activeAudioPlayer = nil
        }
        _audioPlayers.removeValue(forKey: filePath)
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
#if DEBUG
        print("Finished playing \(String(describing: player.url?.path))")
#endif
        _activeAudioPlayer = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
#if DEBUG
        print(
            "Failed decoding \(String(describing: player.url?.path))\n" +
            "Error:\n" +
            String(describing: error)
        )
#endif
        
    }
}
