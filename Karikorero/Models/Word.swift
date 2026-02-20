// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import Foundation

struct Word: Codable, Identifiable, Sendable {
    let id: String
    let teReo: String
    let english: [String]
    let distractors: [String]
    let partOfSpeech: String
    let difficulty: Int
    let audioFile: String
}
