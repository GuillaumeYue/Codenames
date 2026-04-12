//
//  Theme.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI
import UIKit

enum GameColor {
    private static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

    private static func dynamic(light: UIColor, dark: UIColor) -> Color {
        Color(
            UIColor { traits in
                traits.userInterfaceStyle == .dark ? dark : light
            }
        )
    }

    // Backgrounds
    static var background: Color {
        dynamic(light: rgb(0.95, 0.95, 0.97), dark: rgb(0.08, 0.08, 0.10))
    }

    static var panelBackground: Color {
        dynamic(light: rgb(0.90, 0.91, 0.94), dark: rgb(0.18, 0.18, 0.20))
    }

    static var cardPanel: Color {
        dynamic(light: rgb(0.98, 0.98, 1.00), dark: rgb(0.25, 0.25, 0.28))
    }

    // Team colors
    static var teamBlue: Color { Color(rgb(0.29, 0.62, 0.92)) }
    static var teamRed: Color { Color(rgb(0.91, 0.38, 0.30)) }

    // Card colors
    static var cardBlue: Color { Color(rgb(0.22, 0.55, 0.85)) }
    static var cardRed: Color { Color(rgb(0.85, 0.30, 0.22)) }

    static var cardNeutral: Color {
        dynamic(light: rgb(0.85, 0.81, 0.73), dark: rgb(0.76, 0.70, 0.58))
    }

    static var cardAssassin: Color {
        dynamic(light: rgb(0.18, 0.18, 0.22), dark: rgb(0.12, 0.12, 0.14))
    }

    static var cardUnrevealed: Color {
        dynamic(light: rgb(0.91, 0.87, 0.78), dark: rgb(0.83, 0.77, 0.65))
    }

    // Buttons
    static var buttonGreen: Color { Color(rgb(0.30, 0.78, 0.30)) }

    static var buttonGray: Color {
        dynamic(light: rgb(0.82, 0.83, 0.87), dark: rgb(0.28, 0.28, 0.32))
    }

    // Text
    static var textPrimary: Color {
        dynamic(light: rgb(0.09, 0.09, 0.10), dark: .white)
    }

    static var textSecondary: Color {
        dynamic(light: rgb(0.33, 0.33, 0.38), dark: rgb(0.70, 0.70, 0.74))
    }

    static var textOnCard: Color {
        dynamic(light: rgb(0.15, 0.15, 0.15), dark: rgb(0.15, 0.15, 0.15))
    }

    static var textOnRevealedCard: Color { .white }
}
