//
//  SettingsView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct SettingsView: View {

    @ObservedObject var controller: GameController
    @ObservedObject var settings: Settings

    var body: some View {
        NavigationStack {
            Form {
                // SSD-7 message 2.1: toggleSetting(key, isOn)
                Section("Audio") {
                    Toggle("Sound Effects", isOn: Binding(
                        get: { settings.soundEnabled },
                        set: { controller.toggleSetting(key: "sound", isOn: $0) }
                    ))

                    Toggle("Background Music", isOn: Binding(
                        get: { settings.musicEnabled },
                        set: { controller.toggleSetting(key: "music", isOn: $0) }
                    ))
                }

                Section("Feedback") {
                    Toggle("Haptic Feedback", isOn: Binding(
                        get: { settings.hapticEnabled },
                        set: { controller.toggleSetting(key: "haptic", isOn: $0) }
                    ))
                }

                // SSD-7 message 2.3: selectTheme(theme)
                Section("Appearance") {
                    Picker("Theme", selection: Binding(
                        get: { settings.theme },
                        set: { controller.selectTheme($0) }
                    )) {
                        ForEach(ThemeType.allCases, id: \.self) { theme in
                            Text(theme.rawValue.capitalized).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // SSD-7 message 3.1: resetToDefaults()
                Section {
                    Button("Reset to Defaults", role: .destructive) {
                        controller.resetToDefaults()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // SSD-7 message 4: navigateBack()
                    Button("Done") { controller.navigateBack() }
                }
            }
        }
    }
}
