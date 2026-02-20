// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI
import UIKit

enum Theme {
    static let accent = Color("AccentColor")
    static let cardBackground = Color(.systemGray6)
    static let correctGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let incorrectRed = Color(red: 0.9, green: 0.25, blue: 0.25)

    static func ranade(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        let size = UIFont.preferredFont(forTextStyle: style.uiKit).pointSize
        return .custom("Ranade Variable", size: size, relativeTo: style)
            .weight(weight)
    }

    static func ranadeItalic(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        let size = UIFont.preferredFont(forTextStyle: style.uiKit).pointSize
        return .custom("Ranade Variable Italic", size: size, relativeTo: style)
            .weight(weight)
    }

    static func ranadeFixed(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Ranade Variable", fixedSize: size)
            .weight(weight)
    }
}

private extension Font.TextStyle {
    var uiKit: UIFont.TextStyle {
        switch self {
        case .largeTitle: .largeTitle
        case .title: .title1
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .subheadline: .subheadline
        case .body: .body
        case .callout: .callout
        case .footnote: .footnote
        case .caption: .caption1
        case .caption2: .caption2
        @unknown default: .body
        }
    }
}
