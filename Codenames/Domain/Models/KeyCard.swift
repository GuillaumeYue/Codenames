//
//  KeyCard.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//
import Foundation

struct KeyCard: Codable {
    // Record real type of every position（for Spymaster overlay ）
    let assignments: [Int: CardType]   // position -> CardType
    let startingTeam: TeamColor
}
