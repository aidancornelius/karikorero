// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI

struct ScoreBar: View {
    let stats: SessionStats
    let onSettingsTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Label("\(stats.streak)", systemImage: "flame.fill")
                .foregroundStyle(stats.streak > 0 ? Theme.accent : .secondary)
                .font(Theme.ranade(.callout, weight: .semibold))

            Spacer()

            Button(action: onSettingsTap) {
                Image(systemName: "gearshape")
                    .font(.body)
                    .foregroundStyle(Theme.accent)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
