// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI
import UIKit

@main
struct KarikoreApp: App {
    @State private var tipService = TipService()

    init() {
        #if DEBUG
        for family in UIFont.familyNames.sorted() where family.lowercased().contains("ranade") {
            print("Font family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("  -> \(name)")
            }
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            DeckView()
                .preferredColorScheme(.dark)
                .task { tipService.listenForUpdates() }
        }
    }
}
