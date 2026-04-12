//
//  ErrorHandler.swift
//  Codenames
//
//  Iteration 3 - from UC-12 Handle Error Recovery
//  Iteration 3 - from SSD-12 Handle Error Recovery
//  Iteration 3 - from CD-CO40 handleWordBankLoadError
//  Iteration 3 - from CD-CO41 handleBoardGenerationError
//  Iteration 3 - from CD-CO42 handleCorruptedSave
//  Iteration 3 - from CD-CO43 refreshAfterUIError
//  Iteration 3 - from Class Diagram (ErrorHandler)
//

import Foundation

// Iteration 3 - from Class Diagram (ErrorHandler)
final class ErrorHandler {
    private(set) var activeErrors: [String] = []       // Class Diagram (activeErrors : List)
    private(set) var lastErrorType: String = ""         // Class Diagram
    private(set) var lastErrorContext: String = ""      // Class Diagram

    private let errorLog = ErrorLog()                   // Class Diagram (writes to 1..* ErrorLog)

    // Iteration 3 - from CD-CO40 handleWordBankLoadError
    // Iteration 3 - from SSD-12 Handle Error Recovery (messages 1-4)
    func handleWordBankLoadError() -> String {
        lastErrorType = "wordBankLoad"
        lastErrorContext = "Failed to load word bank"
        logError(type: "wordBankLoad")                  // CD-CO40 step 1.1
        return "Word bank could not be loaded. Using backup words."
    }

    // Iteration 3 - from CD-CO41 handleBoardGenerationError
    // Iteration 3 - from SSD-12 Handle Error Recovery (messages 5-8)
    func handleBoardGenerationError() -> String {
        lastErrorType = "boardGeneration"
        lastErrorContext = "Board generation failed"
        logError(type: "boardGeneration")               // CD-CO41 step 1.1
        return "Board generation failed. Please try again."
    }

    // Iteration 3 - from CD-CO42 handleCorruptedSave
    // Iteration 3 - from SSD-12 Handle Error Recovery (messages 9-10)
    func handleCorruptedSave() -> String {
        lastErrorType = "corruptedSave"
        lastErrorContext = "Save file is corrupted"
        logError(type: "corruptedSave")                 // CD-CO42 step 1.2
        return "Your saved game was corrupted and has been removed."
    }

    // Iteration 3 - from CD-CO43 refreshAfterUIError
    // Iteration 3 - from SSD-12 Handle Error Recovery (messages 11-12)
    func refreshAfterUIError() -> RecoveryState {
        lastErrorType = "uiRender"
        lastErrorContext = "UI rendering failure"
        logError(type: "uiRender")                      // CD-CO43 step 1.1
        var recovery = RecoveryState(status: "recovering", fallbackUsed: false)
        recovery.markRecovered()                        // CD-CO43 (RecoveryState created)
        return recovery
    }

    // Iteration 3 - from Class Diagram (logError), CD-CO40 step 1.1, CD-CO41 step 1.1
    func logError(type: String) {
        errorLog.log("Error: \(type) - \(lastErrorContext)")
        activeErrors.append(type)
    }

    // Iteration 3 - from Class Diagram (presentErrorMessage)
    func presentErrorMessage() -> String {
        lastErrorContext
    }
}
