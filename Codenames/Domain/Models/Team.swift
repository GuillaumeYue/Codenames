//
//  Team.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO1, CD-CO4, CD-CO13, CD-CO15
struct Team: Codable {
    let color: TeamColor                // Class Diagram, Domain Model
    var score: Int                      // Class Diagram, Domain Model, CD-CO4 (setScore), CD-CO15 (getScore)
    var targetScore: Int                // Class Diagram, Domain Model, CD-CO4 (setTargetScore), CD-CO15 (getTargetScore)
    var members: [Player]               // Class Diagram (has members 1..*)

    // Class Diagram (incrementWordScore), CD-CO13 step 2
    mutating func incrementWordScore() {
        score += 1
    }

    // CD-CO15 (used by checkWinLoss)
    func hasWon() -> Bool {
        score >= targetScore
    }
}
