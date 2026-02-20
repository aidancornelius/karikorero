// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI

enum ChoiceState {
    case idle
    case highlighted
    case correct
    case incorrect
}

struct ChoiceButton: View {
    let text: String
    let state: ChoiceState
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(Theme.ranade(.body, weight: .medium))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
                .lineLimit(3)
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(foregroundColor)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(fillColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .scaleEffect(state == .highlighted ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: state)
    }

    private var foregroundColor: Color {
        switch state {
        case .idle: .primary
        case .highlighted: Theme.accent
        case .correct: .white
        case .incorrect: .white
        }
    }

    private var fillColor: Color {
        switch state {
        case .idle: Color(.systemGray5)
        case .highlighted: Theme.accent.opacity(0.15)
        case .correct: Theme.correctGreen
        case .incorrect: Theme.incorrectRed
        }
    }

    private var borderColor: Color {
        switch state {
        case .idle: Color(.systemGray4)
        case .highlighted: Theme.accent
        case .correct: Theme.correctGreen
        case .incorrect: Theme.incorrectRed
        }
    }

    private var borderWidth: CGFloat {
        switch state {
        case .idle: 1
        case .highlighted: 2
        case .correct, .incorrect: 2
        }
    }
}
