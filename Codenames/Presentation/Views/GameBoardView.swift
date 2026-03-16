//
//  GameBoardView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct GameBoardView: View {

    @ObservedObject var controller: GameController

    @State private var clueWord: String = ""
    @State private var clueNumberText: String = "1"

    var body: some View {
        guard let game = controller.currentGame else { return AnyView(Text("No Game")) }

        return AnyView(
            VStack(spacing: 12) {
                TeamHeaderView(game: game)

                if game.turnState.turnPhase == .spymaster {
                    VStack(spacing: 8) {
                        Text("Spymaster Phase").bold()

                        TextField("Clue Word", text: $clueWord)
                            .textFieldStyle(.roundedBorder)

                        TextField("Number (0-9, -1 Unlimited)", text: $clueNumberText)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)

                        Button("Submit Clue") {
                            let n = Int(clueNumberText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 1
                            controller.submitClue(clueWord: clueWord, clueNumber: n)
                            clueWord = ""
                        }
                        .buttonStyle(.borderedProminent)

                        if let err = controller.errorMessage {
                            Text(err).foregroundStyle(.red)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 6) {
                        Text("Operative Phase").bold()
                        if let clue = game.turnState.currentClue {
                            Text("Clue: \(clue.word.uppercased()) — \(clue.isUnlimited ? "∞" : "\(clue.number)")")
                                .font(.headline)
                        }
                        Text("Guesses remaining: \(game.turnState.guessesRemaining == -1 ? "∞" : "\(game.turnState.guessesRemaining)")")
                        Button("Pass") { controller.passGuessing() }
                            .buttonStyle(.bordered)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                    ForEach(game.board.cards) { card in
                        CardCellView(card: card) {
                            controller.selectCard(cardId: card.id)
                        }
                    }
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        controller.tapPause()
                    } label: {
                        Image(systemName: "pause.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        )
    }
}
