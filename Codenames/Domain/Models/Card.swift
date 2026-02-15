//
//  Card.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

struct Card: Identifiable, Codable, Equatable {
    let id: UUID
    let word: String
    let position: Int       // 0...24
    let type: CardType
    var isRevealed: Bool
}
