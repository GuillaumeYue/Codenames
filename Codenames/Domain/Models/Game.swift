//
//  Game.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO1, CD-CO4, CD-CO6, CD-CO9, CD-CO11, CD-CO12, CD-CO14, CD-CO15, CD-CO30, CD-CO31, CD-CO33
struct Game: Identifiable, Codable {
    let gameId: UUID                    // Class Diagram, Domain Model
    let gameMode: GameMode              // Class Diagram, Domain Model
    var startTimestamp: Date            // Class Diagram, Domain Model
    var turnNumber: Int                 // Class Diagram, Domain Model, CD-CO4 step 2, CD-CO9 step 3
    var isGameOver: Bool                // Class Diagram, Domain Model, CD-CO11 step 1, CD-CO14 step 1
    var outcome: GameOutcome            // Class Diagram, Domain Model, CD-CO11 step 2, CD-CO14 step 2

    var board: Board                    // Class Diagram (contains 1 Board)
    var keyCard: KeyCard                // Class Diagram (contains 1 KeyCard)
    var red: Team                       // Class Diagram (has 2 Team)
    var blue: Team                      // Class Diagram (has 2 Team)
    var turnState: TurnState            // Class Diagram (tracks TurnState)
    var clueHistory: [Clue]             // Class Diagram (gives 0..* Clue)

    var id: UUID { gameId }

    // Class Diagram (startGameSession), CD-CO1
    mutating func startGameSession() {
        isGameOver = false
        outcome = .none
        turnNumber = 1
        turnState.startSpymasterPhase()
    }

    // Class Diagram (start)
    mutating func start() {
        startGameSession()
    }

    // Class Diagram (endGame), CD-CO12
    mutating func endGame() {
        isGameOver = true
        board.revealAllCards()           // CD-CO12 step 1
    }

    // Class Diagram (incrementTurn), CD-CO9 step 3
    mutating func incrementTurn() {
        turnNumber += 1
    }

    // Class Diagram (setOutcome), CD-CO14 steps 1-2
    mutating func setOutcome(winningTeam: TeamColor) {
        outcome = (winningTeam == .red) ? .redWins : .blueWins
        isGameOver = true
    }

    // Class Diagram (initializeGameState), CD-CO4
    mutating func initializeGameState() {
        let starting = keyCard.startingTeam
        let redSpymaster = Player(name: "Red Spymaster", role: .spymaster)    // CD-CO4 step 5
        let blueSpymaster = Player(name: "Blue Spymaster", role: .spymaster)  // CD-CO4 step 5
        red = Team(color: .red, score: 0, targetScore: (starting == .red ? 9 : 8), members: [redSpymaster])    // CD-CO4 steps 3-4
        blue = Team(color: .blue, score: 0, targetScore: (starting == .blue ? 9 : 8), members: [blueSpymaster]) // CD-CO4 steps 3-4
        turnState = TurnState(
            activeTeam: starting,
            turnPhase: .spymaster,
            guessesRemaining: 0,
            guessesMade: 0,
            currentClue: nil
        )
        isGameOver = false
        outcome = .none
        turnNumber = 1
        clueHistory = []
    }

    // Class Diagram (setGameOver), CD-CO11 steps 1-3
    mutating func setGameOver(reason: String) {
        isGameOver = true                                                      // CD-CO11 step 1
        let loser = turnState.activeTeam
        let winner: TeamColor = (loser == .red) ? .blue : .red
        outcome = (winner == .red) ? .redWins : .blueWins                      // CD-CO11 step 2
    }

    // Class Diagram (checkWinLoss), CD-CO15 steps 1-3
    func checkWinLoss() -> TeamColor? {
        if red.hasWon() { return .red }    // CD-CO15 steps 1-2
        if blue.hasWon() { return .blue }  // CD-CO15 steps 1-2
        return nil
    }

    // CD-CO30 step 1
    mutating func suspendGameplay() {
    }

    // CD-CO31 step 2
    mutating func restoreGameplay() {
    }

    // CD-CO33 step 1
    mutating func discardSession() {
        isGameOver = true
        turnState.clearState()
    }
}
