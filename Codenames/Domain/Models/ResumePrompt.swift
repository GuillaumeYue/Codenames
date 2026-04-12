//
//  ResumePrompt.swift
//  Codenames
//
//  Iteration 3 - from UC-10 Restore Game After Termination
//  Iteration 3 - from SSD-10 Restore Game After Termination
//  Iteration 3 - from Class Diagram (ResumePrompt)
//

import Foundation
import Combine

// Iteration 3 - from Class Diagram (ResumePrompt)
final class ResumePrompt: ObservableObject {
    @Published var isVisible: Bool = false      // Class Diagram
    var savedGame: UUID?                        // Class Diagram
    var lastSaveTime: String = ""               // Class Diagram

    // Iteration 3 - from Class Diagram (show)
    func show() {
        isVisible = true
    }

    // Iteration 3 - from Class Diagram (dismiss)
    func dismiss() {
        isVisible = false
        savedGame = nil
        lastSaveTime = ""
    }

    // Iteration 3 - from Class Diagram (selectResume)
    func selectResume() {
        dismiss()
    }

    // Iteration 3 - from Class Diagram (selectNewGame)
    func selectNewGame() {
        dismiss()
    }
}
