//
//  GameController.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation
import SwiftUI
import Combine

// Class Diagram, CD-CO1 through CD-CO33, SSD-1 through SSD-8
// Iteration 3 - from CD-CO34 through CD-CO43, SSD-9 through SSD-12
@MainActor
final class GameController: ObservableObject {

    @Published private(set) var currentGame: Game? // Class Diagram (currentGame : Game)
    @Published var errorMessage: String?

    let uiManager: UIManager

    private let wordBank = WordBank()
    private let validator = RulesValidator()

    // Iteration 3 - from Class Diagram (PersistenceManager, ErrorHandler, RecoveryManager)
    private let persistenceManager = PersistenceManager()
    private let errorHandler = ErrorHandler()
    private lazy var recoveryManager = RecoveryManager(persistenceManager: persistenceManager)

    init(uiManager: UIManager) {
        self.uiManager = uiManager
        openApplication()
    }

    var mainMenuOptions: [MenuOption] {
        uiManager.mainMenuOptions
    }

    // Class Diagram (openApplication), CD-CO19, SSD-5 step 1
    // Iteration 3 - from SSD-10 Restore Game After Termination (check for saved game on launch)
    func openApplication() {
        uiManager.openApplication()

        // Iteration 3 - from SSD-10 step 2 (savedGameDetected)
        if let savedGame = persistenceManager.readSaveFile() {
            if persistenceManager.validateChecksum(savedGame) {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                let timeStr = formatter.string(from: savedGame.createdAt)
                uiManager.showResumeOrDiscardPrompt(saveId: savedGame.saveId, lastSaveTime: timeStr)
            } else {
                // Iteration 3 - from SSD-10 alt [save data valid] step 8 (corruptedSaveDetected)
                handleCorruptedSave()
            }
        }
    }

    // Class Diagram (startGameSession), CD-CO1, SSD-1
    func startGameSession() {
        let gameID = UUID()
        let start = Date()
        let (board, keyCard) = generateBoard()   // CD-CO2

        currentGame = initializeGameState(gameId: gameID, start: start, board: board, keyCard: keyCard) // CD-CO4
        errorMessage = nil
        uiManager.dismissPauseMenu()
        displayGameBoard()                        // CD-CO5

        // Iteration 3 - from UC-09 Save Game State Automatically (initial save)
        saveAfterStateChange()
    }

    // Class Diagram (generateBoard), CD-CO2, SSD-1 step 2.1
    func generateBoard() -> (Board, KeyCard) {
        // Iteration 3 - from CD-CO40 handleWordBankLoadError (check word bank)
        if !wordBank.hasSufficientWords() {
            handleWordBankLoadError()
        }

        for _ in 0..<20 {
            let words = wordBank.getRandomWords()              // CD-CO2 step 1 (selectWords)
            let startingTeam: TeamColor = Bool.random() ? .red : .blue
            if let generated = buildValidatedBoard(words: words, startingTeam: startingTeam) {
                return generated
            }
        }

        // Iteration 3 - from CD-CO41 handleBoardGenerationError
        // If repeated generation attempts fail, use a safe fallback board.
        let message = errorHandler.handleBoardGenerationError()
        uiManager.displayErrorDialog(message: message)
        if let fallback = buildValidatedBoard(
            words: recoveryManager.fallbackToDefaultBank(),
            startingTeam: Bool.random() ? .red : .blue
        ) {
            return fallback
        }

        // Final guardrail: return a deterministic board instead of blocking startup.
        var emergencyKeyCard = KeyCard(startingTeam: .red, cardAssignments: [:])
        emergencyKeyCard.assignCardTypes()
        let emergencyWords = Array(recoveryManager.fallbackToDefaultBank().prefix(25))
        let emergencyBoard = Board.generateBoard(words: emergencyWords, keyCard: emergencyKeyCard)
        return (emergencyBoard, emergencyKeyCard)
    }

    // Class Diagram (validateBoard), CD-CO3, SSD-1 step 2.2
    func validateBoard(_ board: inout Board) -> Bool {
        let result = board.validate()                          // CD-CO3 step 1 (validate)
        board.boardIsValid = result                            // CD-CO3 step 2 (setBoardIsValid)
        return result
    }

    private func buildValidatedBoard(words: [String], startingTeam: TeamColor) -> (Board, KeyCard)? {
        guard words.count >= 25 else { return nil }

        var keyCard = KeyCard(startingTeam: startingTeam, cardAssignments: [:])
        keyCard.assignCardTypes()                              // CD-CO2 step 4

        var board = Board.generateBoard(words: Array(words.prefix(25)), keyCard: keyCard) // CD-CO2 steps 2-3
        guard validateBoard(&board) else { return nil }        // CD-CO3
        return (board, keyCard)
    }

    // Class Diagram (initializeGameState), CD-CO4, SSD-1 step 3
    func initializeGameState(gameId: UUID, start: Date, board: Board, keyCard: KeyCard) -> Game {
        let startingTeam = keyCard.getStartingTeam()           // CD-CO4 step 1

        let redSpymaster = Player(name: "Red Spymaster", role: .spymaster)    // CD-CO4 step 5
        let blueSpymaster = Player(name: "Blue Spymaster", role: .spymaster)  // CD-CO4 step 5

        let red = Team(color: .red, score: 0, targetScore: (startingTeam == .red ? 9 : 8), members: [redSpymaster])    // CD-CO4 steps 3-4
        let blue = Team(color: .blue, score: 0, targetScore: (startingTeam == .blue ? 9 : 8), members: [blueSpymaster]) // CD-CO4 steps 3-4
        let turnState = TurnState(                             // CD-CO4 step 5 (TurnState creation)
            activeTeam: startingTeam,
            turnPhase: .spymaster,
            guessesRemaining: 0,
            guessesMade: 0,
            currentClue: nil
        )

        return Game(
            gameId: gameId,
            gameMode: .standard,
            startTimestamp: start,
            turnNumber: 1,                                     // CD-CO4 step 2
            isGameOver: false,
            outcome: .none,
            board: board,
            keyCard: keyCard,
            red: red,
            blue: blue,
            turnState: turnState,
            clueHistory: []
        )
    }

    // Class Diagram (displayGameBoard), CD-CO5, SSD-1 step 4
    func displayGameBoard() {
        guard let game = currentGame else { return }
        uiManager.renderBoard(board: game.board.displayGameBoard())  // CD-CO5 step 1
        uiManager.displayTeamIndicator(team: game.turnState.activeTeam) // CD-CO5 step 2
        uiManager.navigateToSpymasterView()                    // CD-CO5 step 3
        uiManager.displayGameBoard()
    }

    // Class Diagram (submitClue), CD-CO6, SSD-2 step 1
    func submitClue(clueWord: String, clueNumber: Int) {
        guard var game = currentGame else { return }
        guard !game.isGameOver else { return }
        guard game.turnState.turnPhase == .spymaster else { return }

        do {
            try validator.validateClue(clueWord: clueWord, clueNumber: clueNumber, board: game.board) // CD-CO6 step 1 (validate)
            game.turnState.submitClue(clueWord: clueWord, clueNumber: clueNumber) // CD-CO6 steps 2, 4, 5
            if let currentClue = game.turnState.currentClue {
                game.clueHistory.append(currentClue)           // CD-CO6 step 3 (addClue)
            }
            currentGame = game
            errorMessage = nil

            // Iteration 3 - from SSD-9 step 4 (significantStateChanged → saveAfterStateChange)
            saveAfterStateChange()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Class Diagram (selectCard), CD-CO7, SSD-2 step 2.1, SSD-3 step 1
    func selectCard(cardId: UUID) {
        guard var game = currentGame else { return }
        guard !game.isGameOver else { return }
        guard game.turnState.turnPhase == .operative else { return }
        guard game.turnState.guessesRemaining == -1 || game.turnState.guessesRemaining > 0 else { return }

        resolveGuess(game: &game, cardId: cardId)              // CD-CO7 step 2 (delegateToResolve)
        currentGame = game

        // Iteration 3 - from SSD-9 step 4 (significantStateChanged → saveAfterStateChange)
        saveAfterStateChange()
    }

    // Class Diagram (passGuessing), CD-CO8, SSD-2 step 2.2
    func passGuessing() {
        guard var game = currentGame else { return }
        guard !game.isGameOver else { return }
        guard game.turnState.turnPhase == .operative else { return }

        game.turnState.passGuessing()                          // CD-CO8 step 1 (setGuessesRemaining(0))
        endTurn(game: &game)                                   // CD-CO8 step 2
        currentGame = game

        // Iteration 3 - from SSD-9 step 4 (significantStateChanged → saveAfterStateChange)
        saveAfterStateChange()
    }

    // Class Diagram (endTurn), CD-CO9, SSD-2 step 3
    func endTurn() {
        guard var game = currentGame else { return }
        endTurn(game: &game)
        currentGame = game
    }

    // Class Diagram (setGameOver), CD-CO11
    func setGameOver(reason: String) {
        guard var game = currentGame else { return }
        setGameOver(game: &game, reason: reason)
        currentGame = game
    }

    // Class Diagram (revealCard), CD-CO10
    func revealCard(cardId: UUID) {
        guard var game = currentGame else { return }
        _ = revealCard(game: &game, cardId: cardId)
        currentGame = game
    }

    // Class Diagram (endGame), CD-CO12
    func endGame() {
        guard var game = currentGame else { return }
        endGame(game: &game)
        currentGame = game
    }

    // Class Diagram (updateBoardState), CD-CO13
    func updateBoardState(cardId: UUID) {
        guard var game = currentGame else { return }
        guard let revealed = game.board.cards.first(where: { $0.id == cardId }) else { return }
        updateBoardState(game: &game, revealed: revealed)
        currentGame = game
    }

    // Class Diagram (setOutcome), CD-CO14
    func setOutcome(winningTeam: TeamColor) {
        guard var game = currentGame else { return }
        setOutcome(game: &game, winningTeam: winningTeam)
        currentGame = game
    }

    // Class Diagram (checkWinLoss), CD-CO15
    func checkWinLoss() -> TeamColor? {
        guard let game = currentGame else { return nil }
        return checkWinLoss(game: game)
    }

    // Class Diagram (selectMenuOption), CD-CO21, SSD-5 step 3.1
    func selectMenuOption(option: MenuOption) {
        uiManager.selectMenuOption(option: option)             // CD-CO21 step 1 (navigateTo)

        switch option.destination {
        case "gameBoard":
            startGameSession()
        case "howToPlay":
            openHowToPlay()
        case "settings":
            openSettings()
        // Iteration 3 - from UC-11 View About Information, CD-CO38
        case "about":
            openAbout()
        default:
            uiManager.navigateTo(screen: option.destination)
        }
    }

    // Class Diagram (displayMainMenu), CD-CO20
    func displayMainMenu() {
        currentGame = nil
        errorMessage = nil
        uiManager.displayMainMenu()                           // CD-CO20 step 1 (renderMainMenu)
    }

    // Class Diagram (navigateBack), CD-CO22, CD-CO25, SSD-5 step 4
    func navigateBack() {
        uiManager.navigateBack()                               // CD-CO22 step 1 (popScreen)
    }

    // Class Diagram (openHowToPlay), CD-CO23, SSD-6 step 1
    func openHowToPlay() {
        uiManager.openHowToPlay()                              // CD-CO23 step 1 (displayHowToPlay)
    }

    // Class Diagram (scrollContent), CD-CO24, SSD-6 step 2.1
    func scrollContent(direction: String, delta: CGFloat) {
        uiManager.scroll(direction: direction, delta: delta)   // CD-CO24 step 1
    }

    // Class Diagram (openSettings), CD-CO26, SSD-7 step 1
    func openSettings() {
        uiManager.openSettings()                               // CD-CO26 steps 1-2
    }

    // Class Diagram (toggleSetting), CD-CO27, SSD-7 step 2.1
    func toggleSetting(key: String, isOn: Bool) {
        uiManager.toggleSetting(key: key, isOn: isOn)         // CD-CO27 steps 1-2
    }

    // Class Diagram (selectTheme), CD-CO28, SSD-7 step 2.3
    func selectTheme(_ theme: ThemeType) {
        uiManager.selectTheme(theme)                           // CD-CO28 steps 1-3
    }

    // Class Diagram (resetToDefaults), CD-CO29, SSD-7 step 3.1
    func resetToDefaults() {
        uiManager.resetToDefaults()                            // CD-CO29 steps 1-3
    }

    // Class Diagram (tapPause), CD-CO30, SSD-8 step 1
    func tapPause() {
        guard var game = currentGame else { return }
        game.suspendGameplay()                                 // CD-CO30 step 1
        currentGame = game
        uiManager.tapPause()                                   // CD-CO30 step 2 (displayPauseMenu)
    }

    // Class Diagram (resumeGame), CD-CO31, SSD-8 step 2.1
    func resumeGame() {
        uiManager.resumeGame()                                 // CD-CO31 step 1 (dismissPauseMenu)
        if var game = currentGame {
            game.restoreGameplay()                             // CD-CO31 step 2
            currentGame = game
        }
    }

    // Class Diagram (requestQuitGame), CD-CO32, SSD-8 step 2.7
    func requestQuitGame() {
        uiManager.requestQuitGame()                            // CD-CO32 step 1 (displayConfirmDialog)
    }

    // Class Diagram (confirmQuit), CD-CO33, SSD-8 step 3.1
    func confirmQuit(confirmation: Bool) {
        uiManager.confirmQuit(confirmation: confirmation)
        if confirmation {
            if var game = currentGame {
                game.discardSession()                          // CD-CO33 steps 1-2 (includes clearState)
                currentGame = game
            }
            currentGame = nil
            errorMessage = nil

            // Iteration 3 - from CD-CO37 (delete save on quit)
            persistenceManager.deleteSaveFile()

            uiManager.navigateToMainMenu()                     // CD-CO33 step 3
        }
    }

    // SSD-3 (Resolve Guess - internal orchestration)
    private func resolveGuess(game: inout Game, cardId: UUID) {
        guard let revealed = revealCard(game: &game, cardId: cardId) else { return } // SSD-3 step 2

        switch revealed.cardType {
        case .assassin:                                        // SSD-3 [Assassin]
            setGameOver(game: &game, reason: "Assassin Selected") // SSD-3 step 3.1
            endGame(game: &game)                               // SSD-3 step 3.2

        case .neutral:                                         // SSD-3 [Wrong Team OR Neutral]
            updateBoardState(game: &game, revealed: revealed)  // SSD-3 step 4.1
            endTurn(game: &game)

        case .red, .blue:                                      // SSD-3 [Correct Team] or [Wrong Team]
            updateBoardState(game: &game, revealed: revealed)  // SSD-3 step 5.1

            if let winner = checkWinLoss(game: game) {         // also handles wrong-team guess that completes opponent words
                setOutcome(game: &game, winningTeam: winner)
                endGame(game: &game)
                return
            }

            let activeTeam = game.turnState.activeTeam
            let selectedTeam: TeamColor = (revealed.cardType == .red) ? .red : .blue

            if selectedTeam != activeTeam {                    // SSD-3 [Wrong Team]
                endTurn(game: &game)
                return
            }

            if game.turnState.guessesRemaining != -1 && game.turnState.guessesRemaining <= 0 {
                endTurn(game: &game)
            }
        }
    }

    // CD-CO10 steps 1-3 (getCard, setIsRevealed, triggerRevealAnimation)
    private func revealCard(game: inout Game, cardId: UUID) -> Card? {
        guard let card = game.board.selectCard(cardId: cardId) else { return nil } // CD-CO10 steps 1-2
        uiManager.triggerRevealAnimation(card: card)           // CD-CO10 step 3
        return card
    }

    // CD-CO13 steps 1-5 (getCardType, incrementScore, decrementGuessesRemaining, incrementGuessesMade, updateDisplay)
    private func updateBoardState(game: inout Game, revealed: Card) {
        switch revealed.cardType {                             // CD-CO13 step 1 (getCardType)
        case .red:
            game.red.incrementWordScore()                      // CD-CO13 step 2
        case .blue:
            game.blue.incrementWordScore()                     // CD-CO13 step 2
        case .neutral, .assassin:
            break
        }

        game.turnState.decrementGuessesRemaining()             // CD-CO13 step 3
        game.turnState.incrementGuessesMade()                  // CD-CO13 step 4
        uiManager.updateDisplay()                              // CD-CO13 step 5
    }

    // CD-CO14 (setOutcome)
    private func setOutcome(game: inout Game, winningTeam: TeamColor) {
        game.setOutcome(winningTeam: winningTeam)              // CD-CO14 steps 1-2
    }

    // CD-CO15 (checkWinLoss)
    private func checkWinLoss(game: Game) -> TeamColor? {
        game.checkWinLoss()                                    // CD-CO15 steps 1-2
    }

    // CD-CO11 (setGameOver)
    private func setGameOver(game: inout Game, reason: String) {
        game.setGameOver(reason: reason)                       // CD-CO11 steps 1-3
    }

    // CD-CO12 (endGame)
    private func endGame(game: inout Game) {
        game.endGame()                                         // CD-CO12 steps 1-2
        let scores = "Red: \(game.red.score)/\(game.red.targetScore) • Blue: \(game.blue.score)/\(game.blue.targetScore)"
        uiManager.displayGameOver(winner: game.outcome, scores: scores) // CD-CO12 step 3
    }

    // CD-CO9 (endTurn)
    private func endTurn(game: inout Game) {
        guard !game.isGameOver else { return }
        game.turnState.endTurn()                               // CD-CO9 steps 1, 2, 4, 5
        game.incrementTurn()                                   // CD-CO9 step 3
        uiManager.displayTeamIndicator(team: game.turnState.activeTeam)
        uiManager.navigateToSpymasterView()
    }

    // MARK: - Iteration 3 Methods

    // Iteration 3 - from UC-09 Save Game State Automatically
    // Iteration 3 - from SSD-9 Save Game State Automatically
    // Iteration 3 - from CD-CO34 autoSaveGameState
    func autoSaveGameState() {
        guard let game = currentGame else { return }
        guard !game.isGameOver else { return }
        persistenceManager.autoSaveGameState(game: game)       // CD-CO34 steps 1.1-1.4
    }

    // Iteration 3 - from UC-09 Save Game State Automatically
    // Iteration 3 - from SSD-9 Save Game State Automatically
    // Iteration 3 - from CD-CO35 saveAfterStateChange
    func saveAfterStateChange() {
        guard let game = currentGame else { return }
        guard !game.isGameOver else { return }
        persistenceManager.saveAfterStateChange(game: game)    // CD-CO35 steps 1.1-1.2
    }

    // Iteration 3 - from UC-10 Restore Game After Termination
    // Iteration 3 - from SSD-10 Restore Game After Termination
    // Iteration 3 - from CD-CO36 restoreSavedGame
    func restoreSavedGame() {
        uiManager.dismissResumePrompt()

        guard let savedGame = persistenceManager.readSaveFile() else {     // CD-CO36 step 1.1 (readSaveFile)
            displayMainMenu()
            return
        }

        guard persistenceManager.validateChecksum(savedGame) else {
            handleCorruptedSave()                                           // SSD-10 alt [save data valid]
            return
        }

        guard let game = savedGame.saveState.rebuildGame() else {           // CD-CO36 steps 1.2-1.4
            handleCorruptedSave()
            return
        }

        currentGame = game                                                  // CD-CO36 (association formed)
        errorMessage = nil
        displayGameBoard()                                                  // CD-CO36 step 1.5
    }

    // Iteration 3 - from UC-10 Restore Game After Termination
    // Iteration 3 - from SSD-10 Restore Game After Termination
    // Iteration 3 - from CD-CO37 discardSavedGame
    func discardSavedGame() {
        uiManager.dismissResumePrompt()
        persistenceManager.deleteSaveFile()                                 // CD-CO37 step 1.1 (deleteSaveFile)
        uiManager.navigateToMainMenu()                                      // CD-CO37 step 1.2
    }

    // Iteration 3 - from UC-11 View About Information
    // Iteration 3 - from SSD-11 View About Information
    // Iteration 3 - from CD-CO38 openAbout
    func openAbout() {
        uiManager.openAbout()                                               // CD-CO38 step 1
    }

    // Iteration 3 - from UC-11 View About Information
    // Iteration 3 - from SSD-11 View About Information
    // Iteration 3 - from CD-CO39 displayAboutInfo
    func displayAboutInfo() {
        let metadata = AppMetadata.fromBundle()
        let info = AboutInfo(
            appName: "Codenames",
            version: metadata.version,                                      // CD-CO39 step 1.1 (getVersion)
            buildNumber: metadata.buildNumber,
            credits: "Antonio Moriello, Han Yue, Apostolos Tsouroupakis",   // CD-CO39 step 1.2 (getCredits)
            copyright: "© 2026 Codenames Team",
            legalNotice: "Codenames is based on the board game by Vlaada Chvátil."
        )
        uiManager.displayAboutScreen(info: info)                            // CD-CO39 step 1.3
    }

    // Iteration 3 - from UC-12 Handle Error Recovery
    // Iteration 3 - from SSD-12 Handle Error Recovery
    // Iteration 3 - from CD-CO40 handleWordBankLoadError
    func handleWordBankLoadError() {
        let message = errorHandler.handleWordBankLoadError()                // CD-CO40 step 1 (logError)
        let fallbackWords = recoveryManager.fallbackToDefaultBank()         // CD-CO40 step 1.2
        if fallbackWords.count >= 25 {
            wordBank.words = fallbackWords
        } else {
            wordBank.loadBackupWords()
        }
        uiManager.displayErrorDialog(message: message)                      // CD-CO40 step 1.3
    }

    // Iteration 3 - from UC-12 Handle Error Recovery
    // Iteration 3 - from SSD-12 Handle Error Recovery
    // Iteration 3 - from CD-CO41 handleBoardGenerationError
    func handleBoardGenerationError() {
        let message = errorHandler.handleBoardGenerationError()             // CD-CO41 step 1 (logError)
        guard var game = currentGame else {
            uiManager.displayErrorDialog(message: message)
            uiManager.refreshCurrentScreen()
            return
        }

        game.board.abortBoardGeneration()                                   // CD-CO41 step 1.2

        if let (fallbackBoard, fallbackKeyCard) = buildValidatedBoard(
            words: recoveryManager.fallbackToDefaultBank(),
            startingTeam: game.keyCard.startingTeam
        ) {
            game.board = fallbackBoard                                      // CD-CO41 step 1.3
            game.keyCard = fallbackKeyCard
        }

        currentGame = game
        uiManager.displayErrorDialog(message: message)
        displayGameBoard()                                                  // CD-CO41 step 1.4
    }

    // Iteration 3 - from UC-12 Handle Error Recovery
    // Iteration 3 - from SSD-12 Handle Error Recovery
    // Iteration 3 - from CD-CO42 handleCorruptedSave
    func handleCorruptedSave() {
        persistenceManager.deleteSaveFile()                                 // CD-CO42 step 1.1 (deleteSaveFile)
        _ = errorHandler.handleCorruptedSave()                              // CD-CO42 step 1.2 (logError)
        uiManager.displayCorruptedSaveMessage()                             // CD-CO42 step 1.3
        uiManager.navigateToMainMenu()                                      // CD-CO42 step 1.4
    }

    // Iteration 3 - from UC-12 Handle Error Recovery
    // Iteration 3 - from SSD-12 Handle Error Recovery
    // Iteration 3 - from CD-CO43 refreshAfterUIError
    func refreshAfterUIError() {
        _ = errorHandler.refreshAfterUIError()                              // CD-CO43 step 1.1 (logError)
        uiManager.refreshCurrentScreen()                                    // CD-CO43 step 1.2
    }
}
