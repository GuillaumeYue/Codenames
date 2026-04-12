//
//  SavedGame.swift
//  Codenames
//
//  Iteration 3 - from UC-09 Save Game State Automatically
//  Iteration 3 - from UC-10 Restore Game After Termination
//  Iteration 3 - from Class Diagram (SavedGame)
//  Iteration 3 - from Domain Model (SavedGame)
//

import Foundation

// Iteration 3 - from Class Diagram (SavedGame), Domain Model
struct SavedGame: Codable {
    let saveId: UUID                    // Class Diagram, Domain Model
    let createdAt: Date                 // Class Diagram, Domain Model
    var isModified: Bool                // Class Diagram, Domain Model
    let schemaVersion: Int              // Class Diagram, Domain Model
    var saveState: SaveState            // Class Diagram (contains SaveState)
}
