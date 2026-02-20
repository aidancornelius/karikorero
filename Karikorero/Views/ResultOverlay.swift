// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI

struct ResultOverlay: View {
    let isCorrect: Bool
    let correctAnswer: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(isCorrect ? Theme.correctGreen : Theme.incorrectRed)

            if !isCorrect {
                Text(correctAnswer)
                    .font(Theme.ranade(.title3, weight: .semibold))
                    .foregroundStyle(.primary)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .transition(.scale.combined(with: .opacity))
    }
}
