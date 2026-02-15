//
//  RulesValidator.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

enum RulesError: Error, LocalizedError {
    case invalidClueWord
    case clueMatchesVisibleWord
    case invalidNumber

    var errorDescription: String? {
        switch self {
        case .invalidClueWord: return "Clue must be a single non-empty word."
        case .clueMatchesVisibleWord: return "Clue cannot match any unrevealed board word."
        case .invalidNumber: return "Clue number must be 0...9, or Unlimited."
        }
    }
}

struct RulesValidator {
    func validateClue(clueWord: String, clueNumber: Int, board: Board) throws {
        let trimmed = clueWord.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed.contains(" ") { throw RulesError.invalidClueWord }

        let visibleWords = board.cards
            .filter { !$0.isRevealed }
            .map { $0.word.lowercased() }

        if visibleWords.contains(trimmed.lowercased()) {
            throw RulesError.clueMatchesVisibleWord
        }

        // Unlimited: -1
        if !(clueNumber == -1 || (0...9).contains(clueNumber)) {
            throw RulesError.invalidNumber
        }
    }
}
