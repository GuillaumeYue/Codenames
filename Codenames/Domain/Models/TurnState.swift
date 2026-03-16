//
//  TurnState.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO4, CD-CO6, CD-CO8, CD-CO9, CD-CO13, CD-CO33
struct TurnState: Codable {
    var activeTeam: TeamColor           // Class Diagram, Domain Model
    var turnPhase: TurnPhase            // Class Diagram, Domain Model
    var guessesRemaining: Int           // Class Diagram, Domain Model
    var guessesMade: Int                // Class Diagram, Domain Model
    var currentClue: Clue?              // Domain Model (current clue 0..1)

    // Class Diagram (startSpymasterPhase), CD-CO9 step 2
    mutating func startSpymasterPhase() {
        turnPhase = .spymaster
        guessesRemaining = 0
        guessesMade = 0
        currentClue = nil
    }

    // Class Diagram (startOperativePhase), CD-CO6 step 4
    mutating func startOperativePhase() {
        turnPhase = .operative
    }

    // Class Diagram (resetGuesses), CD-CO9 step 4
    mutating func resetGuesses() {
        guessesRemaining = 0
        guessesMade = 0
    }

    // Class Diagram (switchTeam), CD-CO9 step 1
    mutating func switchTeam() {
        activeTeam = (activeTeam == .red) ? .blue : .red
        startSpymasterPhase()
    }

    // Class Diagram (submitClue), CD-CO6 steps 2-5
    mutating func submitClue(clueWord: String, clueNumber: Int) {
        let isUnlimited = (clueNumber == -1)
        let clue = Clue(
            word: clueWord.trimmingCharacters(in: .whitespacesAndNewlines),
            number: clueNumber,
            isUnlimited: isUnlimited,
            teamColor: activeTeam,
            timestamp: Date()
        )
        currentClue = clue
        guessesMade = 0
        if isUnlimited {
            guessesRemaining = -1
        } else {
            guessesRemaining = clueNumber + 1
        }
        startOperativePhase()
    }

    // CD-CO9 step 5
    mutating func clearCurrentClue() {
        currentClue = nil
    }

    // CD-CO13 step 3
    mutating func decrementGuessesRemaining() {
        if guessesRemaining != -1 {
            guessesRemaining = max(0, guessesRemaining - 1)
        }
    }

    // CD-CO13 step 4
    mutating func incrementGuessesMade() {
        guessesMade += 1
    }

    // CD-CO33 step 2
    mutating func clearState() {
        activeTeam = .red
        turnPhase = .spymaster
        guessesRemaining = 0
        guessesMade = 0
        currentClue = nil
    }

    // Class Diagram (endTurn), CD-CO9
    mutating func endTurn() {
        switchTeam()
        clearCurrentClue()
    }

    // Class Diagram (passGuessing), CD-CO8 step 1
    mutating func passGuessing() {
        guessesRemaining = 0
    }
}
