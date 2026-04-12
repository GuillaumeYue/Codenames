//
//  SaveManager.swift
//  Codenames
//
//  Iteration 3 - from UC-09 Save Game State Automatically
//  Iteration 3 - from UC-10 Restore Game After Termination
//  Iteration 3 - from Class Diagram (SaveManager)
//

import Foundation

// Iteration 3 - from Class Diagram (SaveManager)
final class SaveManager {
    var inspectedSave: SavedGame?       // Class Diagram (inspectedSave : SaveData)
    var pendingWrite: Bool = false       // Class Diagram (pendingWrite : Boolean)

    // Iteration 3 - from Class Diagram (inspectSaveFile)
    func inspectSaveFile(_ savedGame: SavedGame) -> Bool {
        inspectedSave = savedGame
        return supportedVersion(savedGame)
    }

    // Iteration 3 - from Class Diagram (supportedVersion)
    func supportedVersion(_ savedGame: SavedGame) -> Bool {
        savedGame.schemaVersion == 1
    }

    // Iteration 3 - from Class Diagram (createSaveState)
    func createSaveState(from game: Game) -> SaveState? {
        SaveState.snapshotGame(game)
    }

    // Iteration 3 - from Class Diagram (restoreFromSaveState)
    func restoreFromSaveState(_ saveState: SaveState) -> Game? {
        saveState.rebuildGame()
    }
}
