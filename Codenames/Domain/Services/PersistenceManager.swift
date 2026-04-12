//
//  PersistenceManager.swift
//  Codenames
//
//  Iteration 3 - from UC-09 Save Game State Automatically
//  Iteration 3 - from UC-10 Restore Game After Termination
//  Iteration 3 - from SSD-9 Save Game State Automatically
//  Iteration 3 - from SSD-10 Restore Game After Termination
//  Iteration 3 - from CD-CO34 autoSaveGameState
//  Iteration 3 - from CD-CO35 saveAfterStateChange
//  Iteration 3 - from CD-CO36 restoreSavedGame
//  Iteration 3 - from CD-CO37 discardSavedGame
//  Iteration 3 - from CD-CO42 handleCorruptedSave
//  Iteration 3 - from Class Diagram (PersistenceManager)
//

import Foundation

// Iteration 3 - from Class Diagram (PersistenceManager)
final class PersistenceManager {
    let storageLocation: String         // Class Diagram
    var autoSaveEnabled: Bool           // Class Diagram

    private let saveManager = SaveManager()
    private var lastSaveTimestamp: Date?

    private var saveFileURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent(storageLocation)
    }

    init(storageLocation: String = "codenames_save.json", autoSaveEnabled: Bool = true) {
        self.storageLocation = storageLocation
        self.autoSaveEnabled = autoSaveEnabled
    }

    // Iteration 3 - from CD-CO34 autoSaveGameState
    // Iteration 3 - from SSD-9 Save Game State Automatically
    func autoSaveGameState(game: Game) {
        guard let saveState = SaveState.snapshotGame(game) else { return } // CD-CO34 steps 1.1-1.3

        let savedGame = SavedGame(
            saveId: UUID(),
            createdAt: Date(),
            isModified: false,
            schemaVersion: 1,
            saveState: saveState
        )

        writeSaveFile(data: savedGame)                                     // CD-CO34 step 1.4
        lastSaveTimestamp = Date()
    }

    // Iteration 3 - from CD-CO35 saveAfterStateChange
    // Iteration 3 - from SSD-9 Save Game State Automatically
    func saveAfterStateChange(game: Game) {
        guard autoSaveEnabled else { return }
        guard !saveManager.pendingWrite else { return }

        saveManager.pendingWrite = true
        guard let saveState = SaveState.snapshotGame(game) else {          // CD-CO35 (getCurrentState + snapshot)
            saveManager.pendingWrite = false
            return
        }

        let savedGame = SavedGame(
            saveId: UUID(),
            createdAt: Date(),
            isModified: true,
            schemaVersion: 1,
            saveState: saveState
        )

        writeSaveFile(data: savedGame)                                     // CD-CO35 (writeSaveFile)
        saveManager.pendingWrite = false
    }

    // Iteration 3 - from Class Diagram (readSaveFile), CD-CO36 step 1.1
    func readSaveFile() -> SavedGame? {
        guard FileManager.default.fileExists(atPath: saveFileURL.path) else { return nil }
        guard let data = try? Data(contentsOf: saveFileURL) else { return nil }
        return try? JSONDecoder().decode(SavedGame.self, from: data)
    }

    // Iteration 3 - from Class Diagram (writeSaveFile), CD-CO34 step 1.4, CD-CO35
    func writeSaveFile(data: SavedGame) {
        guard let encoded = try? JSONEncoder().encode(data) else { return }
        try? encoded.write(to: saveFileURL)
    }

    // Iteration 3 - from Class Diagram (deleteSaveFile), CD-CO37 step 1.1, CD-CO42 step 1.1
    func deleteSaveFile() {
        try? FileManager.default.removeItem(at: saveFileURL)
    }

    // Iteration 3 - from Class Diagram (validateChecksum)
    func validateChecksum(_ savedGame: SavedGame) -> Bool {
        guard savedGame.schemaVersion == 1 else { return false }
        return savedGame.saveState.rebuildGame() != nil
    }

    // Iteration 3 - from SSD-10 step 2 (savedGameDetected)
    func hasSavedGame() -> Bool {
        readSaveFile() != nil
    }
}
