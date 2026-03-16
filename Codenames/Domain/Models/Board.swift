//
//  Board.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO2, CD-CO3, CD-CO5, CD-CO7, CD-CO10, CD-CO12, CD-CO13
struct Board: Codable {
    let gridSize: Int = 5               // Class Diagram, Domain Model (gridSize = 5x5)
    var cards: [Card]                   // Class Diagram (contains 25 Card)

    // Class Diagram (generateBoard), CD-CO2 steps 1-3
    static func generateBoard(words: [String], keyCard: KeyCard) -> Board {
        var cards: [Card] = []
        for i in 0..<25 {
            let cardType = keyCard.cardAssignments[i] ?? .neutral
            cards.append(Card(id: UUID(), word: words[i], position: i, cardType: cardType, isRevealed: false))
        }
        return Board(cards: cards)
    }

    // Class Diagram (validateBoard), CD-CO3 step 1
    func validateBoard() -> Bool {
        guard cards.count == 25 else { return false }
        let unique = Set(cards.map { $0.word.lowercased() })
        guard unique.count == 25 else { return false }

        let counts = Dictionary(grouping: cards, by: { $0.cardType }).mapValues { $0.count }
        let total = counts.values.reduce(0, +)
        guard total == 25 else { return false }

        let redCount = counts[.red] ?? 0
        let blueCount = counts[.blue] ?? 0
        let neutralCount = counts[.neutral] ?? 0
        let assassinCount = counts[.assassin] ?? 0

        guard neutralCount == 7, assassinCount == 1 else { return false }
        guard (redCount == 9 && blueCount == 8) || (redCount == 8 && blueCount == 9) else { return false }
        return true
    }

    // Class Diagram (displayGameBoard), CD-CO5 step 1 (renderBoard uses this)
    func displayGameBoard() -> [[Card]] {
        var rows: [[Card]] = []
        for row in 0..<gridSize {
            let start = row * gridSize
            let end = start + gridSize
            rows.append(Array(cards[start..<end]))
        }
        return rows
    }

    // Class Diagram (updateBoardState), CD-CO13
    mutating func updateBoardState(cardId: UUID) {
        guard let idx = cards.firstIndex(where: { $0.id == cardId }) else { return }
        cards[idx].revealCard()
    }

    // CD-CO12 step 1
    mutating func revealAllCards() {
        for i in cards.indices {
            cards[i].revealCard()
        }
    }

    // Class Diagram (selectCard), CD-CO7 step 1, CD-CO10 step 1
    mutating func selectCard(cardId: UUID) -> Card? {
        guard let idx = cards.firstIndex(where: { $0.id == cardId }),
              !cards[idx].isRevealed else { return nil }
        cards[idx].revealCard()
        return cards[idx]
    }
}
