//
//  SaveState.swift
//  Codenames
//
//  Iteration 3 - from UC-09 Save Game State Automatically
//  Iteration 3 - from SSD-9 Save Game State Automatically
//  Iteration 3 - from CD-CO34 autoSaveGameState
//  Iteration 3 - from CD-CO35 saveAfterStateChange
//  Iteration 3 - from Class Diagram (SaveState)
//

import Foundation

// Iteration 3 - from Class Diagram (SaveState), Domain Model
struct SaveState: Codable {
    let serialId: UUID                  // Class Diagram
    let createdAt: Date                 // Class Diagram
    var turnNumber: Int                 // Class Diagram
    var activeTeam: TeamColor           // Class Diagram
    var turnPhase: TurnPhase            // Class Diagram
    var boardSnapshot: Data             // Class Diagram (boardSnapshot : Data)
    var teamSnapshot: Data              // Class Diagram (teamSnapshot : Data)
    var clue: Clue?                     // Class Diagram

    var gameId: UUID
    var gameMode: GameMode
    var startTimestamp: Date
    var isGameOver: Bool
    var outcome: GameOutcome
    var keyCardSnapshot: Data
    var clueHistory: [Clue]
    var guessesRemaining: Int
    var guessesMade: Int

    // Iteration 3 - from CD-CO34 step 1.1 snapshotGame()
    static func snapshotGame(_ game: Game) -> SaveState? {
        guard let boardData = try? JSONEncoder().encode(game.board),
              let teamData = try? JSONEncoder().encode(TeamPair(red: game.red, blue: game.blue)),
              let keyCardData = try? JSONEncoder().encode(game.keyCard) else { return nil }

        return SaveState(
            serialId: UUID(),
            createdAt: Date(),
            turnNumber: game.turnNumber,
            activeTeam: game.turnState.activeTeam,
            turnPhase: game.turnState.turnPhase,
            boardSnapshot: boardData,
            teamSnapshot: teamData,
            clue: game.turnState.currentClue,
            gameId: game.gameId,
            gameMode: game.gameMode,
            startTimestamp: game.startTimestamp,
            isGameOver: game.isGameOver,
            outcome: game.outcome,
            keyCardSnapshot: keyCardData,
            clueHistory: game.clueHistory,
            guessesRemaining: game.turnState.guessesRemaining,
            guessesMade: game.turnState.guessesMade
        )
    }

    // Iteration 3 - from CD-CO34 step 1.2 snapshotBoard()
    func snapshotBoard() -> Data {
        boardSnapshot
    }

    // Iteration 3 - from CD-CO34 step 1.3 snapshotTurnState()
    func snapshotTurnState() -> (TeamColor, TurnPhase, Int, Int, Clue?) {
        (activeTeam, turnPhase, guessesRemaining, guessesMade, clue)
    }

    // Iteration 3 - from CD-CO36 restoreSavedGame (rebuild helpers)
    func rebuildGame() -> Game? {
        guard let board = try? JSONDecoder().decode(Board.self, from: boardSnapshot),
              let teams = try? JSONDecoder().decode(TeamPair.self, from: teamSnapshot),
              let keyCard = try? JSONDecoder().decode(KeyCard.self, from: keyCardSnapshot) else { return nil }

        let turnState = TurnState(
            activeTeam: activeTeam,
            turnPhase: turnPhase,
            guessesRemaining: guessesRemaining,
            guessesMade: guessesMade,
            currentClue: clue
        )

        return Game(
            gameId: gameId,
            gameMode: gameMode,
            startTimestamp: startTimestamp,
            turnNumber: turnNumber,
            isGameOver: isGameOver,
            outcome: outcome,
            board: board,
            keyCard: keyCard,
            red: teams.red,
            blue: teams.blue,
            turnState: turnState,
            clueHistory: clueHistory
        )
    }
}

// Helper for encoding both teams together
struct TeamPair: Codable {
    let red: Team
    let blue: Team
}
