//
//  MenuOption.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO21
struct MenuOption: Identifiable {
    let id: UUID = UUID()
    let optionName: String              // Class Diagram, Domain Model
    let destination: String             // Class Diagram, Domain Model
    let action: (() -> Void)?

    init(optionName: String, destination: String, action: (() -> Void)? = nil) {
        self.optionName = optionName
        self.destination = destination
        self.action = action
    }

    // Class Diagram (execute)
    func execute() {
        action?()
    }
}
