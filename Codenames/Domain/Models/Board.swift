//
//  Board.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

struct Board: Codable {
    let gridSize: Int = 5
    var cards: [Card]       // count == 25
}
