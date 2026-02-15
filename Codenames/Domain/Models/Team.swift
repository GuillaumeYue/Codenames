//
//  Team.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

struct Team: Codable {
    let color: TeamColor
    var score: Int
    var targetScore: Int
}
