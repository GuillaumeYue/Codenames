//
//  RecoveryManager.swift
//  Codenames
//
//  Iteration 3 - from UC-12 Handle Error Recovery
//  Iteration 3 - from SSD-12 Handle Error Recovery
//  Iteration 3 - from Class Diagram (RecoveryManager)
//

import Foundation

// Iteration 3 - from Class Diagram (RecoveryManager)
final class RecoveryManager {
    var recoveryStrategy: String = "default"    // Class Diagram
    var recoveryAttempts: Int = 0               // Class Diagram

    private let persistenceManager: PersistenceManager

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }

    // Iteration 3 - from Class Diagram (restoreSavedGame)
    func restoreSavedGame() -> Game? {
        guard let savedGame = persistenceManager.readSaveFile() else { return nil }
        guard persistenceManager.validateChecksum(savedGame) else { return nil }
        return savedGame.saveState.rebuildGame()
    }

    // Iteration 3 - from Class Diagram (discardSavedGame)
    func discardSavedGame() {
        persistenceManager.deleteSaveFile()
    }

    // Iteration 3 - from Class Diagram (fallbackToDefaultBank), CD-CO40
    func fallbackToDefaultBank() -> [String] {
        recoveryAttempts += 1
        return WordBank.backupWords
    }

    // Iteration 3 - from Class Diagram (loadSafeRecoveryState)
    func loadSafeRecoveryState() -> RecoveryState {
        RecoveryState(status: "recovering", fallbackUsed: true)
    }

    // Iteration 3 - from Class Diagram (retireUI)
    func retireUI() {
        recoveryAttempts = 0
        recoveryStrategy = "default"
    }
}
