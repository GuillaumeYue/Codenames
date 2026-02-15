//
//  WordBank.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

final class WordBank {
    // Change to .txt or .json afterwards
    private let words: [String] = [
        "APPLE","RIVER","MOON","SPIKE","GLASS","TRAIN","KING","CODE","MAP","CLOUD",
        "FROST","NINJA","PIRATE","BRIDGE","SNOW","PLANE","RING","NOTE","LASER","ROBOT",
        "JAZZ","WHALE","STONE","CHAIR","BREAD","FIRE","STORM","WIND","PARK","STAR"
    ]

    func randomWords(count: Int) -> [String] {
        Array(words.shuffled().prefix(count))
    }
}
