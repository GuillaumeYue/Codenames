//
//  Player.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO4 step 5
struct Player: Codable, Identifiable {
    let id: UUID
    var name: String                    // Class Diagram, Domain Model
    var role: PlayerRole                // Class Diagram, Domain Model

    init(name: String, role: PlayerRole = .operative) {
        self.id = UUID()
        self.name = name
        self.role = role
    }

    // Class Diagram (assignRole)
    mutating func assignRole(_ role: PlayerRole) {
        self.role = role
    }
}
