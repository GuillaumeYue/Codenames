//
//  Menu.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model
struct Menu {
    let menuType: MenuType              // Class Diagram, Domain Model
    private(set) var options: [MenuOption] = [] // Class Diagram (contains MenuOption)

    init(menuType: MenuType, options: [MenuOption] = []) {
        self.menuType = menuType
        self.options = options
    }

    // Class Diagram (getOptions)
    func getOptions() -> [MenuOption] {
        return options
    }

    // Class Diagram (navigateBack)
    func navigateBack() {
    }
}
