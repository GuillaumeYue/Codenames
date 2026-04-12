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

    // Iteration 3 - from UC-09 Save Game State Automatically
    // Iteration 3 - from SSD-9 Save Game State Automatically (appWillEnterBackground)
    @Environment(\.scenePhase) private var scenePhase

    init() {
        let uiManager = UIManager()
        _uiManager = StateObject(wrappedValue: uiManager)
        _gameController = StateObject(wrappedValue: GameController(uiManager: uiManager))
    }

    var body: some View {
        ZStack {
            GameColor.background
                .ignoresSafeArea()

            switch uiManager.currentScreen {
            case "gameBoard":
                NavigationStack {
                    GameBoardView(controller: gameController)
                }
                .id(gameController.currentGame?.gameId)
            case "gameOver":
                NavigationStack {
                    GameOverView(controller: gameController)
                }
            case "splashScreen":
                VStack(spacing: 16) {
                    Text("CODENAMES")
                        .font(.system(size: 42, weight: .black))
                        .tracking(4)
                        .foregroundStyle(GameColor.textPrimary)
                    ProgressView()
                        .tint(GameColor.teamBlue)
                }
            default:
                MainMenuView(controller: gameController)
            }

            if uiManager.pauseMenu.isVisible && uiManager.currentScreen == "gameBoard" {
                PauseMenuView(controller: gameController)
            }
        }
        .preferredColorScheme(preferredColorScheme)
        .sheet(item: $uiManager.presentedModal) { modal in
            switch modal {
            case .howToPlay:
                HowToPlayView(controller: gameController, guide: uiManager.helpGuide)
            case .settings:
                SettingsView(controller: gameController, settings: uiManager.settings)
            // Iteration 3 - from UC-11 View About Information
            // Iteration 3 - from SSD-11 View About Information
            // Iteration 3 - from CD-CO38 openAbout
            case .about:
                AboutView(controller: gameController, viewModel: uiManager.aboutViewModel)
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
        // Iteration 3 - from UC-10 Restore Game After Termination
        // Iteration 3 - from SSD-10 Restore Game After Termination
        .alert("Saved Game Found", isPresented: $uiManager.showResumePrompt) {
            Button("Resume") {
                gameController.restoreSavedGame()
            }
            Button("New Game", role: .destructive) {
                gameController.discardSavedGame()
            }
        } message: {
            Text("A previous game was found. Would you like to resume?")
        }
        // Iteration 3 - from UC-12 Handle Error Recovery
        // Iteration 3 - from SSD-12 Handle Error Recovery
        .alert("Error", isPresented: $uiManager.showErrorDialog) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(uiManager.errorDialogMessage)
        }
        // Iteration 3 - from SSD-9 step 1 (appWillEnterBackground → autoSaveGameState)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                gameController.autoSaveGameState()
            }
        }
    }

    private var preferredColorScheme: ColorScheme? {
        switch uiManager.settings.theme {
        case .dark:
            return .dark
        case .light:
            return .light
        case .classic:
            return nil
        }
    }
}
