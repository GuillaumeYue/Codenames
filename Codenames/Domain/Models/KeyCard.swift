//
//  KeyCard.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//
import Foundation

// Class Diagram, Domain Model, CD-CO2 step 4, CD-CO4 step 1
struct KeyCard: Codable {
    let startingTeam: TeamColor         // Class Diagram, Domain Model
    var cardAssignments: [Int: CardType] // Class Diagram, Domain Model (contains 25)

    // CD-CO4 step 1
    func getStartingTeam() -> TeamColor {
        startingTeam
    }

    // Class Diagram (assignCardTypes), CD-CO2 step 4
    mutating func assignCardTypes() {
        let startColor: CardType = (startingTeam == .red) ? .red : .blue
        let otherColor: CardType = (startingTeam == .red) ? .blue : .red

        var types: [CardType] =
            Array(repeating: startColor, count: 9) +
            Array(repeating: otherColor, count: 8) +
            Array(repeating: .neutral, count: 7) +
            [.assassin]
        types.shuffle()

        for i in 0..<25 {
            cardAssignments[i] = types[i]
        }
    }
}
