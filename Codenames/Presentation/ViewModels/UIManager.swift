//
//  UIManager.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation
import SwiftUI
import Combine

// Class Diagram, CD-CO5, CD-CO10, CD-CO12, CD-CO13, CD-CO19, CD-CO20, CD-CO21, CD-CO22, CD-CO23, CD-CO24, CD-CO25, CD-CO26, CD-CO28, CD-CO29, CD-CO30, CD-CO31, CD-CO32, CD-CO33
// Iteration 3 - from CD-CO38, CD-CO39, CD-CO42, CD-CO43
@MainActor
final class UIManager: ObservableObject {

    enum PresentedModal: String, Identifiable {
        case howToPlay
        case settings
        // Iteration 3 - from UC-11 View About Information
        case about

        var id: String { rawValue }
    }

    @Published private(set) var currentScreen: String = "mainMenu" // Class Diagram, Domain Model
    @Published var presentedModal: PresentedModal?
    @Published var showQuitConfirmation: Bool = false
    @Published private(set) var activeTeamIndicator: TeamColor?

    // Iteration 3 - from UC-10 Restore Game After Termination, Class Diagram (ResumePrompt)
    @Published var showResumePrompt: Bool = false

    // Iteration 3 - from UC-12 Handle Error Recovery
    @Published var showErrorDialog: Bool = false
    @Published var errorDialogMessage: String = ""

    let mainMenu: MainMenu              // Class Diagram (displays MainMenu)
    let pauseMenu: PauseMenu            // Class Diagram (opens PauseMenu)
    let settings: Settings              // Class Diagram (opens Settings)
    let helpGuide: HelpGuide            // Class Diagram (uses HelpGuide)

    // Iteration 3 - from Class Diagram (ResumePrompt)
    let resumePrompt: ResumePrompt

    // Iteration 3 - from Class Diagram (AboutViewModel)
    let aboutViewModel: AboutViewModel

    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.mainMenu = MainMenu()
        self.pauseMenu = PauseMenu()
        self.settings = Settings()
        self.helpGuide = HelpGuide.openHowToPlay()
        self.resumePrompt = ResumePrompt()
        self.aboutViewModel = AboutViewModel()

        // Keep root views reactive to nested Settings changes (theme/switches).
        settings.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    var mainMenuOptions: [MenuOption] {
        mainMenu.options
    }

    // Class Diagram (openApplication), CD-CO19
    func openApplication() {
        displaySplashScreen()            // CD-CO19 step 2
        mainMenu.openApplication()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.displayMainMenu()
        }
    }

    // Class Diagram (renderBoard), CD-CO5 step 1
    func renderBoard(board: [[Card]]) {
        _ = board
        navigateTo(screen: "gameBoard")
    }

    // Class Diagram (displayTeamIndicator), CD-CO5 step 2
    func displayTeamIndicator(team: TeamColor) {
        activeTeamIndicator = team
    }

    // Class Diagram (displayGameOver), CD-CO12 step 3
    func displayGameOver(winner: GameOutcome, scores: String) {
        _ = winner
        _ = scores
        dismissPauseMenu()
        navigateTo(screen: "gameOver")
    }

    // Class Diagram (navigateTo), CD-CO21 step 1
    func navigateTo(screen: String) {
        currentScreen = screen
        if screen == "mainMenu" {
            mainMenu.displayMainMenu()
        } else {
            mainMenu.isVisible = false
        }
    }

    // Class Diagram (displaySplashScreen), CD-CO19 step 2
    func displaySplashScreen() {
        currentScreen = "splashScreen"
    }

    // Class Diagram (navigateToSpymasterView), CD-CO5 step 3
    func navigateToSpymasterView() {
        if currentScreen != "gameBoard" {
            currentScreen = "gameBoard"
        }
    }

    // Class Diagram (applySettings), CD-CO29 step 3
    func applySettings() {
        objectWillChange.send()
    }

    // Class Diagram (displayMainMenu), CD-CO20 step 1 (renderMainMenu)
    func displayMainMenu() {
        presentedModal = nil
        showQuitConfirmation = false
        dismissPauseMenu()
        navigateTo(screen: "mainMenu")
    }

    // Class Diagram (popScreen), CD-CO22 step 1
    func popScreen() {
        navigateBack()
    }

    // Class Diagram (displayHowToPlay), CD-CO23 step 1
    func displayHowToPlay() {
        presentedModal = .howToPlay
    }

    // Class Diagram (displaySettings), CD-CO26 step 1
    func displaySettings() {
        presentedModal = .settings
    }

    // Class Diagram (applyTheme), CD-CO28 step 2
    func applyTheme() {
        objectWillChange.send()
    }

    // Class Diagram (displayPauseMenu), CD-CO30 step 2
    func displayPauseMenu() {
        pauseMenu.tapPause()
    }

    // Class Diagram (displayConfirmDialog), CD-CO32 step 1
    func displayConfirmDialog() {
        showQuitConfirmation = true
    }

    // Class Diagram (scroll), CD-CO24 step 1
    func scroll(direction: String, delta: CGFloat) {
        helpGuide.scrollContent(direction: direction, delta: delta)
    }

    // CD-CO10 step 3
    func triggerRevealAnimation(card: Card) {
        _ = card
    }

    // CD-CO13 step 5
    func updateDisplay() {
        objectWillChange.send()
    }

    // CD-CO33 step 3
    func navigateToMainMenu() {
        displayMainMenu()
    }

    // Class Diagram (dismissPauseMenu), CD-CO31 step 1
    func dismissPauseMenu() {
        pauseMenu.hide()
    }

    // Class Diagram (displayGameBoard)
    func displayGameBoard() {
        navigateTo(screen: "gameBoard")
    }

    // Class Diagram (selectMenuOption), CD-CO21
    func selectMenuOption(option: MenuOption) {
        mainMenu.selectMenuOption(option: option)
    }

    // Class Diagram (openHowToPlay), CD-CO23
    func openHowToPlay() {
        displayHowToPlay()
    }

    // Class Diagram (openSettings), CD-CO26
    func openSettings() {
        settings.openSettings()          // CD-CO26 (loadCurrentSettings)
        applySettings()
        displaySettings()                // CD-CO26 step 1
    }

    // Class Diagram (navigateBack), CD-CO22, CD-CO25
    func navigateBack() {
        presentedModal = nil
        showQuitConfirmation = false
    }

    // Class Diagram (toggleSetting), CD-CO27
    func toggleSetting(key: String, isOn: Bool) {
        settings.toggleSetting(key: key, isOn: isOn) // CD-CO27 step 1 (setValue)
        applySettings()
    }

    // Class Diagram (selectTheme), CD-CO28
    func selectTheme(_ theme: ThemeType) {
        settings.selectTheme(theme)      // CD-CO28 step 1 (setTheme)
        applyTheme()                     // CD-CO28 step 2
    }

    // Class Diagram (resetToDefaults), CD-CO29
    func resetToDefaults() {
        settings.resetToDefaults()       // CD-CO29 steps 1-2
        applySettings()                  // CD-CO29 step 3
    }

    // Class Diagram (tapPause), CD-CO30
    func tapPause() {
        displayPauseMenu()               // CD-CO30 step 2
    }

    // Class Diagram (resumeGame), CD-CO31
    func resumeGame() {
        pauseMenu.resumeGame()
        dismissPauseMenu()               // CD-CO31 step 1
    }

    // Class Diagram (requestQuitGame), CD-CO32
    func requestQuitGame() {
        pauseMenu.requestQuitGame()
        displayConfirmDialog()           // CD-CO32 step 1
    }

    // Class Diagram (confirmQuit), CD-CO33
    func confirmQuit(confirmation: Bool) {
        pauseMenu.confirmQuit(confirmation: confirmation)
        showQuitConfirmation = false
        if confirmation {
            dismissPauseMenu()
        }
    }

    // MARK: - Iteration 3 Methods

    // Iteration 3 - from CD-CO38 openAbout
    // Iteration 3 - from SSD-11 View About Information
    func openAbout() {
        aboutViewModel.openAbout()                      // CD-CO38 step 1.1 (displayAbout)
        presentedModal = .about
    }

    // Iteration 3 - from CD-CO39 displayAboutInfo
    // Iteration 3 - from SSD-11 View About Information
    func displayAboutScreen(info: AboutInfo) {
        _ = info
        presentedModal = .about
    }

    // Iteration 3 - from CD-CO42 handleCorruptedSave
    // Iteration 3 - from SSD-12 Handle Error Recovery
    func displayCorruptedSaveMessage() {
        errorDialogMessage = "Your saved game was corrupted and has been removed."
        showErrorDialog = true
    }

    // Iteration 3 - from CD-CO43 refreshAfterUIError
    // Iteration 3 - from SSD-12 Handle Error Recovery
    func refreshCurrentScreen() {
        objectWillChange.send()
        restoreSafeState()                              // CD-CO43 step 1.3
    }

    // Iteration 3 - from CD-CO43 step 1.3 (restoreSafeState)
    func restoreSafeState() {
        if currentScreen != "mainMenu" && currentScreen != "gameBoard" {
            navigateTo(screen: "mainMenu")
        }
    }

    // Iteration 3 - from CD-CO40, CD-CO41 (displayErrorDialog)
    // Iteration 3 - from SSD-12 Handle Error Recovery
    func displayErrorDialog(message: String) {
        errorDialogMessage = message
        showErrorDialog = true
    }

    // Iteration 3 - from SSD-10 Restore Game After Termination (resumeOrDiscardPromptDisplayed)
    func showResumeOrDiscardPrompt(saveId: UUID, lastSaveTime: String) {
        resumePrompt.savedGame = saveId
        resumePrompt.lastSaveTime = lastSaveTime
        resumePrompt.show()
        showResumePrompt = true
    }

    // Iteration 3 - from SSD-10 (dismiss resume prompt)
    func dismissResumePrompt() {
        resumePrompt.dismiss()
        showResumePrompt = false
    }
}
