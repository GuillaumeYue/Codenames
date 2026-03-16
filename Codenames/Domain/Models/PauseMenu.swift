//
//  PauseMenu.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation
import Combine

// Class Diagram, Domain Model, CD-CO30, CD-CO31, CD-CO32, CD-CO33
final class PauseMenu: ObservableObject {
    @Published var isVisible: Bool = false  // Class Diagram, Domain Model

    private var onResume: (() -> Void)?
    private var onQuit: (() -> Void)?

    init(onResume: (() -> Void)? = nil, onQuit: (() -> Void)? = nil) {
        self.onResume = onResume
        self.onQuit = onQuit
    }

    // Class Diagram (tapPause), CD-CO30
    func tapPause() {
        show()
    }

    // Class Diagram (show)
    func show() {
        isVisible = true
    }

    // Class Diagram (hide)
    func hide() {
        isVisible = false
    }

    // Class Diagram (resumeGame), CD-CO31
    func resumeGame() {
        hide()
        onResume?()
    }

    // Class Diagram (requestQuitGame), CD-CO32
    func requestQuitGame() {
    }

    // Class Diagram (confirmQuit), CD-CO33
    func confirmQuit(confirmation: Bool) {
        if confirmation {
            hide()
            onQuit?()
        }
    }
}
