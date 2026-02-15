//
//  GameViewModel.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {

    @Published private(set) var game: Game?
    @Published var errorMessage: String?
    @Published var showGameOver: Bool = false

    private let service = GameService()

    func startNewGame() {
        let g = service.startGameSession()
        self.game = g
        self.showGameOver = false
        self.errorMessage = nil
    }

    func submitClue(word: String, number: Int) {
        guard var g = game else { return }
        do {
            try service.submitClue(game: &g, clueWord: word, clueNumber: number)
            game = g
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func tapCard(_ id: UUID) {
        guard var g = game else { return }
        service.selectCard(game: &g, cardId: id)
        game = g
        if g.isGameOver { showGameOver = true }
    }

    func pass() {
        guard var g = game else { return }
        service.passGuessing(game: &g)
        game = g
    }

    func backToMenu() {
        game = nil
        showGameOver = false
    }
}
