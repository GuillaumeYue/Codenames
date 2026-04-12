//
//  MainMenu.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation
import Combine

// Class Diagram, Domain Model, CD-CO19, CD-CO20, CD-CO21
final class MainMenu: ObservableObject {
    @Published var isVisible: Bool = true   // Class Diagram, Domain Model

    private let menu: Menu
    var options: [MenuOption] { menu.getOptions() }

    // Iteration 3 - from UC-11 View About Information (About added to Main Menu)
    init() {
        self.menu = Menu(menuType: .mainMenu, options: [
            MenuOption(optionName: "New Game", destination: "gameBoard"),
            MenuOption(optionName: "How to Play", destination: "howToPlay"),
            MenuOption(optionName: "Settings", destination: "settings"),
            MenuOption(optionName: "About", destination: "about")
        ])
    }

    // Class Diagram (openApplication), CD-CO19
    func openApplication() {
        displaySplashScreen()
        displayMainMenu()
    }

    // Class Diagram (displaySplashScreen), CD-CO19 step 2
    func displaySplashScreen() {
    }

    // Class Diagram (displayMainMenu), CD-CO20
    func displayMainMenu() {
        isVisible = true
    }

    // Class Diagram (selectMenuOption), CD-CO21
    func selectMenuOption(option: MenuOption) {
        option.execute()
    }

    // Class Diagram (navigateTo)
    func navigateTo(screen: String) {
    }
}
