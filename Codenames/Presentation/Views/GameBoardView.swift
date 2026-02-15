//
//  GameBoardView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI
import Combine

struct GameBoardView: View {

    @ObservedObject var vm: GameViewModel

    @State private var clueWord: String = ""
    @State private var clueNumberText: String = "1"

    var body: some View {
        guard let game = vm.game else { return AnyView(Text("No Game")) }

        return AnyView(
            VStack(spacing: 12) {
                TeamHeaderView(game: game)

                if game.turnState.phase == .spymaster {
                    VStack(spacing: 8) {
                        Text("Spymaster Phase").bold()

                        TextField("Clue Word", text: $clueWord)
                            .textFieldStyle(.roundedBorder)

                        TextField("Number (0-9, -1 Unlimited)", text: $clueNumberText)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)

                        Button("Submit Clue") {
                            let n = Int(clueNumberText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 1
                            vm.submitClue(word: clueWord, number: n)
                            clueWord = ""
                        }
                        .buttonStyle(.borderedProminent)

                        if let err = vm.errorMessage {
                            Text(err).foregroundStyle(.red)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 6) {
                        Text("Operative Phase").bold()
                        Text("Guesses remaining: \(game.turnState.guessesRemaining == -1 ? "∞" : "\(game.turnState.guessesRemaining)")")
                        Button("Pass") { vm.pass() }
                            .buttonStyle(.bordered)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                    ForEach(game.board.cards) { card in
                        CardCellView(card: card) {
                            vm.tapCard(card.id)
                        }
                    }
                }
                .padding()

                NavigationLink("", isActive: $vm.showGameOver) {
                    GameOverView(vm: vm)
                }
                .hidden()
            }
            .navigationTitle("Game")
            .navigationBarTitleDisplayMode(.inline)
        )
    }
}
