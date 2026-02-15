//
//  TurnState.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

struct TurnState: Codable {
    var activeTeam: TeamColor
    var phase: TurnPhase
    var guessesRemaining: Int   // -1 means unlimited
    var guessesMade: Int
    var currentClue: Clue?
}
