//
//  Card.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO2 step 3, CD-CO10, CD-CO12 step 2, CD-CO13 step 1
struct Card: Identifiable, Codable, Equatable {
    let id: UUID
    let word: String                    // Class Diagram, Domain Model
    let position: Position              // Class Diagram (position : Position), Domain Model
    let cardType: CardType              // Class Diagram, Domain Model, CD-CO13 step 1 (getCardType)
    var isRevealed: Bool                // Class Diagram, Domain Model, CD-CO10 step 2, CD-CO12 step 2

    // Class Diagram (revealCard), CD-CO10 step 2 (setIsRevealed), CD-CO12 step 2 (setIsRevealed)
    mutating func revealCard() {
        isRevealed = true
    }
}
