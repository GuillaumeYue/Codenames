//
//  WordBank.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO2 step 1
final class WordBank {
    let fileName: String                // Class Diagram, Domain Model
    var words: [String]                 // Class Diagram, Domain Model

    // Iteration 3 - from CD-CO40 handleWordBankLoadError (backup word list)
    static let backupWords: [String] = [
        "APPLE","RIVER","MOON","SPIKE","GLASS","TRAIN","KING","CODE","MAP","CLOUD",
        "FROST","NINJA","PIRATE","BRIDGE","SNOW","PLANE","RING","NOTE","LASER","ROBOT",
        "JAZZ","WHALE","STONE","CHAIR","BREAD"
    ]

    init(fileName: String = "default") {
        self.fileName = fileName
        self.words = [
            "APPLE","RIVER","MOON","SPIKE","GLASS","TRAIN","KING","CODE","MAP","CLOUD",
            "FROST","NINJA","PIRATE","BRIDGE","SNOW","PLANE","RING","NOTE","LASER","ROBOT",
            "JAZZ","WHALE","STONE","CHAIR","BREAD","FIRE","STORM","WIND","PARK","STAR",
            "BANK","EAGLE","HORN","SHADOW","MERCURY","DIAMOND","CASTLE","ANCHOR","BOLT","SILK",
            "ORBIT","CRANE","TORCH","MARBLE","GHOST","TEMPLE","CROWN","JUNGLE","IRON","ROCKET"
        ]
    }

    // Class Diagram (getRandomWords), CD-CO2 step 1 (selectWords)
    func getRandomWords() -> [String] {
        Array(words.shuffled().prefix(25))
    }

    // Class Diagram (hasWord)
    func hasWord(_ word: String) -> Bool {
        words.contains(where: { $0.caseInsensitiveCompare(word) == .orderedSame })
    }

    // Iteration 3 - from CD-CO40 handleWordBankLoadError (fallback support)
    func loadBackupWords() {
        words = WordBank.backupWords
    }

    // Iteration 3 - from CD-CO40 (check if word bank has sufficient words)
    func hasSufficientWords() -> Bool {
        words.count >= 25
    }
}
