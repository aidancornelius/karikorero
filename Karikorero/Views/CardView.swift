// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI

struct CardView: View {
    let teReo: String
    let partOfSpeech: String
    let onPlayAudio: () -> Void
    var listeningMode: Bool = false

    var dragOffset: CGSize = .zero
    var isAnswered: Bool = false

    private var rotation: Double {
        Double(dragOffset.width) / 25.0
    }

    private var dragProgress: Double {
        min(abs(dragOffset.width) / 150.0, 1.0)
    }

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            if listeningMode {
                Image(systemName: "ear.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            } else {
                Text(teReo)
                    .font(Theme.ranade(.largeTitle, weight: .bold))
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)

                Text(partOfSpeech)
                    .font(Theme.ranade(.body, weight: .light))
                    .foregroundStyle(.secondary)
            }

            Button(action: onPlayAudio) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.accent)
                    .padding(16)
                    .background(
                        Circle()
                            .fill(Theme.accent.opacity(0.15))
                    )
            }
            .padding(.top, 8)
            .disabled(isAnswered)

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Theme.cardBackground)
                .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(dragTintColor.opacity(dragProgress * 0.6), lineWidth: 3)
        )
        .offset(dragOffset)
        .rotationEffect(.degrees(rotation))
        .opacity(1.0 - dragProgress * 0.2)
    }

    private var dragTintColor: Color {
        dragOffset.width != 0 ? Theme.accent : .clear
    }
}
