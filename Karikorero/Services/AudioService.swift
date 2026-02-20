// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import AVFoundation
import SwiftUI

@Observable
@MainActor
final class AudioService {
    private var wordPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?

    init() {
        configureSession()
    }

    func playWord(_ filename: String) {
        guard !allSoundsMuted else { return }
        guard let url = bundleURL(for: filename) else { return }
        do {
            wordPlayer = try AVAudioPlayer(contentsOf: url)
            wordPlayer?.play()
        } catch {
            // Missing audio shouldn't crash the app
        }
    }

    func playCorrect() {
        guard !allSoundsMuted, soundEffectsEnabled else { return }
        playEffect("correct")
    }

    func playIncorrect() {
        guard !allSoundsMuted, soundEffectsEnabled else { return }
        playEffect("incorrect")
    }

    private var allSoundsMuted: Bool {
        UserDefaults.standard.bool(forKey: "allSoundsMuted")
    }

    private var soundEffectsEnabled: Bool {
        UserDefaults.standard.object(forKey: "soundEffectsEnabled") as? Bool ?? true
    }

    private func playEffect(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "caf", subdirectory: "Audio")
                ?? Bundle.main.url(forResource: name, withExtension: "m4a", subdirectory: "Audio") else {
            return
        }
        do {
            effectPlayer = try AVAudioPlayer(contentsOf: url)
            effectPlayer?.volume = 0.5
            effectPlayer?.play()
        } catch {
            // Silent failure
        }
    }

    private func bundleURL(for filename: String) -> URL? {
        let name = (filename as NSString).deletingPathExtension
        let ext = (filename as NSString).pathExtension
        return Bundle.main.url(forResource: name, withExtension: ext, subdirectory: "Audio")
    }

    private func configureSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Audio session config failure — not fatal
        }
    }
}
