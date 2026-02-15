//
//  Enums.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

enum TeamColor: String, Codable { case red, blue }
enum TurnPhase: String, Codable { case spymaster, operative }

enum CardType: String, Codable {
    case red, blue, neutral, assassin
}
