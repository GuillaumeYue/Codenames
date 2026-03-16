//
//  Clue.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO6 step 2
struct Clue: Codable {
    let word: String                    // Class Diagram, Domain Model
    let number: Int                     // Class Diagram, Domain Model
    let isUnlimited: Bool               // Class Diagram, Domain Model
    let teamColor: TeamColor            // Class Diagram, Domain Model
    let timestamp: Date                 // Class Diagram, Domain Model

    init(word: String, number: Int, isUnlimited: Bool = false, teamColor: TeamColor, timestamp: Date = Date()) {
        self.word = word
        self.number = isUnlimited ? -1 : number
        self.isUnlimited = isUnlimited
        self.teamColor = teamColor
        self.timestamp = timestamp
    }

    // Class Diagram (isValid)
    func isValid() -> Bool {
        let trimmed = word.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !trimmed.contains(" ") else { return false }
        guard isUnlimited || (0...9).contains(number) else { return false }
        return true
    }
}
