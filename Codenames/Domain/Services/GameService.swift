//
//  GameService.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

final class GameService {

    private let wordBank = WordBank()
    private let validator = RulesValidator()

    // ===== CO-1 startGameSession() =====
    func startGameSession() -> Game {
        let gameId = UUID()
        let start = Date()

        // board generation pipeline (CO-2, CO-3)
        let (board, keyCard) = generateValidBoard()

        // CO-4
        let game = initializeGameState(gameId: gameId, start: start, board: board, keyCard: keyCard)

        // CO-5 displayGameBoard() is UI behavior，do nothing except return
        return game
    }

    // ===== CO-2 generateBoard() + CO-3 validateBoard() =====
    private func generateValidBoard() -> (Board, KeyCard) {
        while true {
            let words = wordBank.randomWords(count: 25)
            let (board, keyCard) = generateBoard(words: words)
            if validateBoard(board: board, keyCard: keyCard) {
                return (board, keyCard)
            }
        }
    }

    // CO-2
    private func generateBoard(words: [String]) -> (Board, KeyCard) {
        // starting team random
        let startingTeam: TeamColor = Bool.random() ? .red : .blue
        let otherTeam: TeamColor = (startingTeam == .red) ? .blue : .red

        // distribution: 9 starting, 8 other, 7 neutral, 1 assassin
        var types: [CardType] =
            Array(repeating: startingTeam == .red ? .red : .blue, count: 9) +
            Array(repeating: otherTeam == .red ? .red : .blue, count: 8) +
            Array(repeating: .neutral, count: 7) +
            [.assassin]
        types.shuffle()

        var cards: [Card] = []
        var assignments: [Int: CardType] = [:]

        for i in 0..<25 {
            let t = types[i]
            assignments[i] = t
            cards.append(Card(id: UUID(), word: words[i], position: i, type: t, isRevealed: false))
        }

        return (Board(cards: cards), KeyCard(assignments: assignments, startingTeam: startingTeam))
    }

    // CO-3
    private func validateBoard(board: Board, keyCard: KeyCard) -> Bool {
        guard board.cards.count == 25 else { return false }
        let unique = Set(board.cards.map { $0.word.lowercased() })
        guard unique.count == 25 else { return false }

        let counts = Dictionary(grouping: board.cards, by: { $0.type }).mapValues { $0.count }
        let total = counts.values.reduce(0,+)
        guard total == 25 else { return false }

        // Determin Blue/Red team has 8/9 words
        let redCount = counts[.red] ?? 0
        let blueCount = counts[.blue] ?? 0
        let neutralCount = counts[.neutral] ?? 0
        let assassinCount = counts[.assassin] ?? 0

        guard neutralCount == 7, assassinCount == 1 else { return false }
        guard (redCount == 9 && blueCount == 8) || (redCount == 8 && blueCount == 9) else { return false }

        // keyCard assignments
        guard keyCard.assignments.count == 25 else { return false }
        return true
    }

    // ===== CO-4 initializeGameState() =====
    private func initializeGameState(gameId: UUID, start: Date, board: Board, keyCard: KeyCard) -> Game {
        let starting = keyCard.startingTeam
        let other: TeamColor = (starting == .red) ? .blue : .red

        let startTarget = 9
        let otherTarget = 8

        var red = Team(color: .red, score: 0, targetScore: (starting == .red ? startTarget : otherTarget))
        var blue = Team(color: .blue, score: 0, targetScore: (starting == .blue ? startTarget : otherTarget))

        let turn = TurnState(activeTeam: starting, phase: .spymaster, guessesRemaining: 0, guessesMade: 0, currentClue: nil)

        return Game(
            id: gameId,
            isGameOver: false,
            startTimestamp: start,
            turnNumber: 1,
            board: board,
            keyCard: keyCard,
            red: red,
            blue: blue,
            turnState: turn,
            clueHistory: [],
            outcome: nil
        )
    }

    // ===== CO-6 submitClue(clueWord, clueNumber) =====
    func submitClue(game: inout Game, clueWord: String, clueNumber: Int) throws {
        guard !game.isGameOver else { return }
        guard game.turnState.phase == .spymaster else { return }

        try validator.validateClue(clueWord: clueWord, clueNumber: clueNumber, board: game.board)

        let clue = Clue(
            word: clueWord.trimmingCharacters(in: .whitespacesAndNewlines),
            number: clueNumber,
            team: game.turnState.activeTeam,
            timestamp: Date()
        )
        game.clueHistory.append(clue)

        game.turnState.phase = .operative
        game.turnState.guessesMade = 0
        game.turnState.currentClue = clue

        // guessesRemaining = clueNumber + 1, unlimited  -1
        if clueNumber == -1 {
            game.turnState.guessesRemaining = -1
        } else {
            game.turnState.guessesRemaining = clueNumber + 1
        }
    }

    // ===== CO-7 selectCard(cardId) =====
    func selectCard(game: inout Game, cardId: UUID) {
        guard !game.isGameOver else { return }
        guard game.turnState.phase == .operative else { return }

        // guessesRemaining > 0 or unlimited
        if game.turnState.guessesRemaining != -1 && game.turnState.guessesRemaining <= 0 { return }

        guard let idx = game.board.cards.firstIndex(where: { $0.id == cardId }) else { return }
        guard game.board.cards[idx].isRevealed == false else { return }

        // trigger SSD-3 flow：reveal -> update -> check win/loss / switch / end
        resolveGuess(game: &game, cardIndex: idx)
    }

    // ===== CO-8 passGuessing() =====
    func passGuessing(game: inout Game) {
        guard !game.isGameOver else { return }
        guard game.turnState.phase == .operative else { return }
        game.turnState.guessesRemaining = 0
        endTurn(game: &game) // CO-9
    }

    // ===== SSD-3 flow =====
    private func resolveGuess(game: inout Game, cardIndex: Int) {
        // CO-10 revealCard
        revealCard(game: &game, cardIndex: cardIndex)

        let revealed = game.board.cards[cardIndex]
        switch revealed.type {

        case .assassin:
            // CO-11 setGameOver + CO-12 endGame
            setGameOver(game: &game, reason: "Assassin Selected")
            endGame(game: &game)

        case .neutral:
            // CO-13 updateBoardState + CO-14 switchTurn
            updateBoardState(game: &game, revealed: revealed)
            switchTurn(game: &game)

        case .red, .blue:
            // CO-13
            updateBoardState(game: &game, revealed: revealed)

            // if hit opposite team word：Game Over（CO-14）
            let active = game.turnState.activeTeam
            let pickedTeam: TeamColor = (revealed.type == .red) ? .red : .blue

            if pickedTeam != active {
                switchTurn(game: &game)
                return
            }

            // correct team: CO-15 checkWinLoss
            let winner = checkWinLoss(game: &game)
            if let winner {
                setGameOutcome(game: &game, winner: winner)  // CO-16/17
                endGame(game: &game)                         // CO-12
                return
            }

            // no winner: if guesses remaining hit 0 -> end turn
            if game.turnState.guessesRemaining != -1 && game.turnState.guessesRemaining <= 0 {
                endTurn(game: &game) // CO-9
            }
        }
    }

    // CO-10
    private func revealCard(game: inout Game, cardIndex: Int) {
        game.board.cards[cardIndex].isRevealed = true
    }

    // CO-11
    private func setGameOver(game: inout Game, reason: String) {
        game.isGameOver = true
        // winner is the opposing team
        let loser = game.turnState.activeTeam
        let winner: TeamColor = (loser == .red) ? .blue : .red
        game.outcome = (winner == .red) ? "Red Team Wins" : "Blue Team Wins"
        _ = reason
    }

    // CO-12
    private func endGame(game: inout Game) {
        // reveal all
        for i in game.board.cards.indices {
            game.board.cards[i].isRevealed = true
        }
        // UI navigates to GameOverView controled by viewmodel
    }

    // CO-13
    private func updateBoardState(game: inout Game, revealed: Card) {
        let active = game.turnState.activeTeam

        func teamRef(_ color: TeamColor) -> UnsafeMutablePointer<Team> {
            if color == .red {
                return .allocate(capacity: 1)
            } else {
                return .allocate(capacity: 1)
            }
        }
        if revealed.type == .red {
            if active == .red {
                game.red.score += 1
                decrementGuess(game: &game)
            } else {
                game.red.score += 1
            }
        } else if revealed.type == .blue {
            if active == .blue {
                game.blue.score += 1
                decrementGuess(game: &game)
            } else {
                game.blue.score += 1
            }
        } else if revealed.type == .neutral {
            // no score
        }
    }

    private func decrementGuess(game: inout Game) {
        game.turnState.guessesMade += 1
        if game.turnState.guessesRemaining != -1 {
            game.turnState.guessesRemaining -= 1
        }
    }

    // CO-14
    private func switchTurn(game: inout Game) {
        endTurn(game: &game) // CO-9
    }

    // CO-15 (returns winner if exists)
    private func checkWinLoss(game: inout Game) -> TeamColor? {
        if game.red.score >= game.red.targetScore { return .red }
        if game.blue.score >= game.blue.targetScore { return .blue }
        return nil
    }

    // CO-16/17
    private func setGameOutcome(game: inout Game, winner: TeamColor) {
        game.isGameOver = true
        game.outcome = (winner == .red) ? "Red Team Wins" : "Blue Team Wins"
    }

    // CO-9 endTurn()
    func endTurn(game: inout Game) {
        guard !game.isGameOver else { return }
        let current = game.turnState.activeTeam
        game.turnState.activeTeam = (current == .red) ? .blue : .red
        game.turnState.phase = .spymaster
        game.turnState.guessesRemaining = 0
        game.turnState.guessesMade = 0
        game.turnState.currentClue = nil
        game.turnNumber += 1
    }
}
