//
//  RecoveryState.swift
//  Codenames
//
//  Iteration 3 - from UC-12 Handle Error Recovery
//  Iteration 3 - from Class Diagram (RecoveryState)
//

import Foundation

// Iteration 3 - from Class Diagram (RecoveryState), Domain Model
struct RecoveryState {
    var status: String                  // Class Diagram
    var fallbackUsed: Bool              // Class Diagram

    // Iteration 3 - from Class Diagram (reset)
    mutating func reset() {
        status = "idle"
        fallbackUsed = false
    }

    // Iteration 3 - from Class Diagram (markRecovered)
    mutating func markRecovered() {
        status = "recovered"
    }
}
