//
//  Game.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

struct Game: Codable {
    let id: UUID
    var isGameOver: Bool
    var startTimestamp: Date
    var turnNumber: Int

    var board: Board
    var keyCard: KeyCard
    var red: Team
    var blue: Team
    var turnState: TurnState

    var clueHistory: [Clue]
    var outcome: String?    // "Red Team Wins" / "Blue Team Wins" / nil
}
