// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import SwiftUI

struct SettingsView: View {
    @AppStorage("allSoundsMuted") private var allSoundsMuted = false
    @AppStorage("soundEffectsEnabled") private var soundEffectsEnabled = true
    @AppStorage("listeningMode") private var listeningMode = false
    @Environment(\.dismiss) private var dismiss

    var stats: SessionStats?
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                if let stats {
                    Section {
                        statRow("Words Seen", value: "\(stats.totalSeen)")
                        statRow("Correct", value: "\(stats.totalCorrect)")
                        if stats.totalSeen > 0 {
                            statRow("Accuracy", value: "\(Int(stats.accuracy * 100))%")
                        }
                        statRow("Best Streak", value: "\(stats.bestStreak)")

                        Button {
                            showResetConfirmation = true
                        } label: {
                            Label("Reset My Statistics", systemImage: "arrow.counterclockwise")
                                .foregroundStyle(Theme.accent)
                        }
                    } header: {
                        Text("Your Progress")
                    }
                }

                Section {
                    Toggle(isOn: $allSoundsMuted) {
                        Label("Mute All Sounds", systemImage: "speaker.slash")
                    }

                    if !allSoundsMuted {
                        Toggle(isOn: $soundEffectsEnabled) {
                            Label("Sound Effects", systemImage: "speaker.wave.2")
                        }
                    }
                } header: {
                    Text("Audio")
                } footer: {
                    Text("Mute all sounds disables word pronunciation and sound effects. Your device's silent switch is also respected.")
                }

                Section {
                    Toggle(isOn: $listeningMode) {
                        Label("Listening Mode", systemImage: "ear.fill")
                    }
                } header: {
                    Text("Practice")
                } footer: {
                    Text("Hides the Māori word on the card — listen to the pronunciation and pick the correct answer by ear.")
                }

                Section {
                    Text("Ngā mihi nui ki a koe mō te whakamahi i tēnei taupānga! Thanks for trying out Karikorero — I hope it helps on your Te Reo Māori journey.\n\nMade with 💛 by Aidan Cornelius-Bell.")
                        .font(Theme.ranadeItalic(.callout))
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Kia ora")
                }

                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Māori TTS")
                            .font(Theme.ranade(.body, weight: .medium))
                        Text("Speech synthesis by KingsleyEng's Maori TTS.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Credits")
                }
            }
            .tint(Theme.accent)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.accent)
                }
            }
            .confirmationDialog(
                "Reset all statistics?",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset") {
                    stats?.resetStats()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset your words seen, accuracy, and best streak. This cannot be undone.")
            }
        }
    }

    private func statRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .font(Theme.ranade(.body, weight: .semibold))
                .foregroundStyle(Theme.accent)
        }
    }
}
