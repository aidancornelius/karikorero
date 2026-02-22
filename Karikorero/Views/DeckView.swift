// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI

struct DeckView: View {
    @State private var wordService = WordService()
    @State private var stats = SessionStats()
    @State private var audioService = AudioService()
    @State private var showSettings = false
    @AppStorage("listeningMode") private var listeningMode = false

    @State private var dragOffset: CGSize = .zero
    @State private var answerResult: AnswerResult?
    @State private var isAnswered = false
    @State private var cardID = UUID()

    private let swipeThreshold: CGFloat = 60
    private let velocityThreshold: CGFloat = 300

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ScoreBar(stats: stats, onSettingsTap: { showSettings = true })
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                if let prompt = wordService.currentPrompt {
                    // Card area
                    CardView(
                        teReo: prompt.word.teReo,
                        partOfSpeech: prompt.word.partOfSpeech,
                        onPlayAudio: { audioService.playWord(prompt.word.audioFile) },
                        listeningMode: listeningMode,
                        dragOffset: dragOffset,
                        isAnswered: isAnswered
                    )
                    .id(cardID)
                    .gesture(swipeGesture(prompt: prompt))
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 20)

                    // Two choices side by side
                    choiceButtons(prompt)
                        .id(cardID)
                        .padding(.horizontal, 16)
                        .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? 8 : 16)
                } else {
                    Spacer()
                }
            }
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showSettings) {
            SettingsView(stats: stats)
        }
        .overlay {
            if let result = answerResult {
                ResultOverlay(
                    isCorrect: result.isCorrect,
                    correctAnswer: result.correctAnswer
                )
            }
        }
    }

    @ViewBuilder
    private func choiceButtons(_ prompt: CardPrompt) -> some View {
        let leftText = prompt.correctOnLeft ? prompt.correctAnswer : prompt.distractor
        let rightText = prompt.correctOnLeft ? prompt.distractor : prompt.correctAnswer

        HStack(spacing: 12) {
            ChoiceButton(
                text: leftText,
                state: choiceState(isCorrectSide: prompt.correctOnLeft, side: .left),
                onTap: { answer(choseLeft: true, prompt: prompt) }
            )

            ChoiceButton(
                text: rightText,
                state: choiceState(isCorrectSide: !prompt.correctOnLeft, side: .right),
                onTap: { answer(choseLeft: false, prompt: prompt) }
            )
        }
        .frame(height: 100)
    }

    private enum Side { case left, right }

    private func choiceState(isCorrectSide: Bool, side: Side) -> ChoiceState {
        if isAnswered, let result = answerResult {
            if isCorrectSide {
                return .correct
            } else if (side == .left && result.choseLeft) || (side == .right && !result.choseLeft) {
                return result.isCorrect ? .correct : .incorrect
            }
            return .idle
        }

        let draggingToward: Bool = switch side {
        case .left: dragOffset.width < -30
        case .right: dragOffset.width > 30
        }
        return draggingToward ? .highlighted : .idle
    }

    private func swipeGesture(prompt: CardPrompt) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard !isAnswered else { return }
                dragOffset = value.translation
            }
            .onEnded { value in
                guard !isAnswered else { return }
                let distance = abs(value.translation.width)
                let velocity = abs(value.predictedEndTranslation.width - value.translation.width)
                if distance > swipeThreshold || velocity > velocityThreshold {
                    let choseLeft = value.translation.width < 0
                    answer(choseLeft: choseLeft, prompt: prompt)
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        dragOffset = .zero
                    }
                }
            }
    }

    private func answer(choseLeft: Bool, prompt: CardPrompt) {
        guard !isAnswered else { return }
        isAnswered = true

        let isCorrect = (choseLeft && prompt.correctOnLeft) || (!choseLeft && !prompt.correctOnLeft)

        let finalOffset: CGSize = choseLeft
            ? CGSize(width: -400, height: 0)
            : CGSize(width: 400, height: 0)

        if isCorrect {
            stats.recordCorrect()
            audioService.playCorrect()
        } else {
            stats.recordIncorrect()
            audioService.playIncorrect()
        }

        let result = AnswerResult(
            isCorrect: isCorrect,
            correctAnswer: prompt.correctAnswer,
            choseLeft: choseLeft
        )
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            answerResult = result
            dragOffset = finalOffset
        }

        let delay: TimeInterval = isCorrect ? 0.6 : 1.2
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            advanceCard()
        }
    }

    private func advanceCard() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            answerResult = nil
            dragOffset = .zero
            isAnswered = false
            cardID = UUID()
            wordService.advance()
        }

        if let prompt = wordService.currentPrompt {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                audioService.playWord(prompt.word.audioFile)
            }
        }
    }
}

private struct AnswerResult {
    let isCorrect: Bool
    let correctAnswer: String
    let choseLeft: Bool
}
