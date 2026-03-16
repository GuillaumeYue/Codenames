//
//  Settings.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation
import Combine

// Class Diagram, Domain Model, CD-CO26, CD-CO27, CD-CO28, CD-CO29
final class Settings: ObservableObject, Codable {
    @Published var soundEnabled: Bool   // Class Diagram, Domain Model
    @Published var musicEnabled: Bool   // Class Diagram, Domain Model
    @Published var hapticEnabled: Bool  // Class Diagram, Domain Model
    @Published var theme: ThemeType     // Class Diagram, Domain Model

    enum CodingKeys: String, CodingKey {
        case soundEnabled, musicEnabled, hapticEnabled, theme
    }

    init(soundEnabled: Bool = true, musicEnabled: Bool = true, hapticEnabled: Bool = true, theme: ThemeType = .classic) {
        self.soundEnabled = soundEnabled
        self.musicEnabled = musicEnabled
        self.hapticEnabled = hapticEnabled
        self.theme = theme
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        soundEnabled = try container.decode(Bool.self, forKey: .soundEnabled)
        musicEnabled = try container.decode(Bool.self, forKey: .musicEnabled)
        hapticEnabled = try container.decode(Bool.self, forKey: .hapticEnabled)
        theme = try container.decode(ThemeType.self, forKey: .theme)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(soundEnabled, forKey: .soundEnabled)
        try container.encode(musicEnabled, forKey: .musicEnabled)
        try container.encode(hapticEnabled, forKey: .hapticEnabled)
        try container.encode(theme, forKey: .theme)
    }

    private static let storageKey = "appSettings"

    // Class Diagram (openSettings), CD-CO26
    func openSettings() {
        loadCurrentSettings()
    }

    // CD-CO29 step 1
    func resetAll() {
        soundEnabled = true
        musicEnabled = true
        hapticEnabled = true
        theme = .classic
    }

    // Class Diagram (resetToDefaults), CD-CO29
    func resetToDefaults() {
        resetAll()                       // CD-CO29 step 1
        persist()                        // CD-CO29 step 2
    }

    // Class Diagram (save → persist), CD-CO27 step 2, CD-CO28 step 3
    func persist() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }

    // Class Diagram (load → loadCurrentSettings), CD-CO26 step 2
    func loadCurrentSettings() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode(Settings.self, from: data) else { return }
        self.soundEnabled = decoded.soundEnabled
        self.musicEnabled = decoded.musicEnabled
        self.hapticEnabled = decoded.hapticEnabled
        self.theme = decoded.theme
    }

    // Class Diagram (toggleSetting), CD-CO27 step 1 (setValue)
    func toggleSetting(key: String, isOn: Bool) {
        switch key {
        case "sound": soundEnabled = isOn
        case "music": musicEnabled = isOn
        case "haptic": hapticEnabled = isOn
        default: break
        }
        persist()                        // CD-CO27 step 2
    }

    // Class Diagram (selectTheme), CD-CO28 step 1 (setTheme)
    func selectTheme(_ theme: ThemeType) {
        self.theme = theme
        persist()                        // CD-CO28 step 3
    }
}
