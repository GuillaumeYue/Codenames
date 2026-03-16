//
//  ContentView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-05.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var uiManager: UIManager
    @StateObject private var gameController: GameController

    init() {
        let uiManager = UIManager()
        _uiManager = StateObject(wrappedValue: uiManager)
        _gameController = StateObject(wrappedValue: GameController(uiManager: uiManager))
    }

    var body: some View {
        ZStack {
            switch uiManager.currentScreen {
            case "gameBoard":
                NavigationStack {
                    GameBoardView(controller: gameController)
                }
            case "gameOver":
                NavigationStack {
                    GameOverView(controller: gameController)
                }
            case "splashScreen":
                VStack(spacing: 16) {
                    Text("CODENAMES")
                        .font(.system(size: 42, weight: .black))
                        .tracking(4)
                    ProgressView()
                }
            default:
                MainMenuView(controller: gameController)
            }

            if uiManager.pauseMenu.isVisible && uiManager.currentScreen == "gameBoard" {
                PauseMenuView(controller: gameController)
            }
        }
        .sheet(item: $uiManager.presentedModal) { modal in
            switch modal {
            case .howToPlay:
                HowToPlayView(controller: gameController, guide: uiManager.helpGuide)
            case .settings:
                SettingsView(controller: gameController, settings: uiManager.settings)
            }
        }
        .alert("Quit Game?", isPresented: $uiManager.showQuitConfirmation) {
            Button("Cancel", role: .cancel) {
                gameController.confirmQuit(confirmation: false)
            }
            Button("Quit", role: .destructive) {
                gameController.confirmQuit(confirmation: true)
            }
        } message: {
            Text("Your current game progress will be lost.")
        }
    }
}
