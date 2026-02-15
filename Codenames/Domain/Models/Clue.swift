//
//  Clue.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

struct Clue: Codable {
    let word: String
    let number: Int          // 0...9 or -1 means Unlimited
    let team: TeamColor
    let timestamp: Date
}
