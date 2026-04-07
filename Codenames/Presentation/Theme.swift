//
//  Theme.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

enum GameColor {
    // Background colors (from screenshot: dark/black base)
    static let background = Color(red: 0.08, green: 0.08, blue: 0.10)
    static let panelBackground = Color(red: 0.18, green: 0.18, blue: 0.20)
    static let cardPanel = Color(red: 0.25, green: 0.25, blue: 0.28)

    // Team colors (from screenshot: vibrant blue and coral-red)
    static let teamBlue = Color(red: 0.29, green: 0.62, blue: 0.92)
    static let teamRed = Color(red: 0.91, green: 0.38, blue: 0.30)

    // Card revealed colors
    static let cardBlue = Color(red: 0.22, green: 0.55, blue: 0.85)
    static let cardRed = Color(red: 0.85, green: 0.30, blue: 0.22)
    static let cardNeutral = Color(red: 0.76, green: 0.70, blue: 0.58)
    static let cardAssassin = Color(red: 0.12, green: 0.12, blue: 0.14)

    // Unrevealed card (tan/beige like real Codenames cards)
    static let cardUnrevealed = Color(red: 0.83, green: 0.77, blue: 0.65)

    // Button colors (from screenshot: bright green CTA)
    static let buttonGreen = Color(red: 0.30, green: 0.78, blue: 0.30)
    static let buttonGray = Color(red: 0.28, green: 0.28, blue: 0.32)

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.70, green: 0.70, blue: 0.74)
    static let textOnCard = Color(red: 0.15, green: 0.15, blue: 0.15)
    static let textOnRevealedCard = Color.white
}
