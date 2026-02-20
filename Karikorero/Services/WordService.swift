// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import Foundation

struct CardPrompt: Sendable {
    let word: Word
    let correctAnswer: String
    let distractor: String
    let correctOnLeft: Bool
}

@Observable
@MainActor
final class WordService {
    private var allWords: [Word] = []
    private var deck: [Word] = []
    private(set) var currentPrompt: CardPrompt?

    init() {
        loadWords()
        shuffle()
        advance()
    }

    func advance() {
        if deck.isEmpty {
            shuffle()
        }
        guard let word = deck.popLast() else { return }

        let correctAnswer = word.english.randomElement() ?? word.english[0]
        let distractor = word.distractors.randomElement() ?? word.distractors[0]
        let correctOnLeft = Bool.random()

        currentPrompt = CardPrompt(
            word: word,
            correctAnswer: correctAnswer,
            distractor: distractor,
            correctOnLeft: correctOnLeft
        )
    }

    private func loadWords() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json", subdirectory: "Data"),
              let data = try? Data(contentsOf: url),
              let words = try? JSONDecoder().decode([Word].self, from: data) else {
            return
        }
        allWords = words
    }

    private func shuffle() {
        deck = allWords.shuffled()
    }
}
