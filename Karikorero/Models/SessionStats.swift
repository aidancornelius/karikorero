// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI

@Observable
@MainActor
final class SessionStats {
    private(set) var streak: Int = 0
    private(set) var bestStreak: Int {
        get { UserDefaults.standard.integer(forKey: "bestStreak") }
        set { UserDefaults.standard.set(newValue, forKey: "bestStreak") }
    }
    private(set) var totalCorrect: Int {
        get { UserDefaults.standard.integer(forKey: "totalCorrect") }
        set { UserDefaults.standard.set(newValue, forKey: "totalCorrect") }
    }
    private(set) var totalSeen: Int {
        get { UserDefaults.standard.integer(forKey: "totalSeen") }
        set { UserDefaults.standard.set(newValue, forKey: "totalSeen") }
    }

    var accuracy: Double {
        guard totalSeen > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalSeen)
    }

    func recordCorrect() {
        totalSeen += 1
        totalCorrect += 1
        streak += 1
        if streak > bestStreak { bestStreak = streak }
    }

    func recordIncorrect() {
        totalSeen += 1
        streak = 0
    }

    func resetStats() {
        streak = 0
        UserDefaults.standard.set(0, forKey: "bestStreak")
        UserDefaults.standard.set(0, forKey: "totalCorrect")
        UserDefaults.standard.set(0, forKey: "totalSeen")
    }
}
