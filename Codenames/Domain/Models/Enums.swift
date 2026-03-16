//
//  Enums.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model
enum TeamColor: String, Codable { case red, blue }
enum TurnPhase: String, Codable { case spymaster, operative }

// Class Diagram, Domain Model
enum CardType: String, Codable {
    case red, blue, neutral, assassin
}

// Class Diagram, Domain Model
enum PlayerRole: String, Codable { case spymaster, operative }

// Class Diagram (Settings.theme : ThemeType)
enum ThemeType: String, Codable, CaseIterable {
    case classic, dark, light
}

// Class Diagram (Menu.menuType : MenuType)
enum MenuType: String, Codable {
    case mainMenu, pauseMenu
}

// Class Diagram (Game.outcome : GameOutcome)
enum GameOutcome: String, Codable {
    case redWins = "Red Team Wins"
    case blueWins = "Blue Team Wins"
    case none
}

// Class Diagram (Game.gameMode : GameMode)
enum GameMode: String, Codable {
    case standard
}

// Class Diagram (Card.position : Position)
typealias Position = Int
