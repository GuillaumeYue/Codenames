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
        ZStack {
            GameColor.background
                .ignoresSafeArea()

            if let game = controller.currentGame {
                VStack(spacing: 10) {
                    TeamHeaderView(game: game)

                    // Phase input area
                    if game.turnState.turnPhase == .spymaster {
                        spymasterPanel(game: game)
                    } else {
                        operativePanel(game: game)
                    }

                    // Card grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 5), spacing: 6) {
                        ForEach(game.board.cards) { card in
                            CardCellView(card: card) {
                                controller.selectCard(cardId: card.id)
                            }
                        }
                    }
                    .padding(.horizontal, 10)

                    Spacer()
                }
                .id(game.gameId)
            } else {
                Text("No Game")
                    .foregroundStyle(GameColor.textSecondary)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    controller.tapPause()
                } label: {
                    Image(systemName: "pause.circle.fill")
                        .font(.title2)
                        .foregroundStyle(GameColor.textSecondary)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(GameColor.panelBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private func spymasterPanel(game: Game) -> some View {
        VStack(spacing: 8) {
            Text("SPYMASTER PHASE")
                .font(.caption.bold())
                .tracking(2)
                .foregroundStyle(
                    game.turnState.activeTeam == .red ? GameColor.teamRed : GameColor.teamBlue
                )

            HStack(spacing: 8) {
                TextField("Clue Word", text: $clueWord)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(GameColor.cardPanel)
                    .foregroundStyle(GameColor.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                TextField("#", text: $clueNumberText)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .frame(width: 56)
                    .background(GameColor.cardPanel)
                    .foregroundStyle(GameColor.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)

                Button {
                    let n = Int(clueNumberText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 1
                    controller.submitClue(clueWord: clueWord, clueNumber: n)
                    clueWord = ""
                } label: {
                    Text("SUBMIT")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(GameColor.buttonGreen)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 12)

            if let err = controller.errorMessage {
                Text(err)
                    .font(.caption)
                    .foregroundStyle(GameColor.teamRed)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(GameColor.panelBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 10)
    }

    private func operativePanel(game: Game) -> some View {
        VStack(spacing: 6) {
            Text("OPERATIVE PHASE")
                .font(.caption.bold())
                .tracking(2)
                .foregroundStyle(
                    game.turnState.activeTeam == .red ? GameColor.teamRed : GameColor.teamBlue
                )

            if let clue = game.turnState.currentClue {
                HStack(spacing: 12) {
                    Text(clue.word.uppercased())
                        .font(.title2.bold())
                        .foregroundStyle(GameColor.textPrimary)

                    Text(clue.isUnlimited ? "∞" : "\(clue.number)")
                        .font(.title2.bold())
                        .foregroundStyle(
                            game.turnState.activeTeam == .red ? GameColor.teamRed : GameColor.teamBlue
                        )
                }
            }

            HStack(spacing: 16) {
                Text("Guesses: \(game.turnState.guessesRemaining == -1 ? "∞" : "\(game.turnState.guessesRemaining)")")
                    .font(.subheadline)
                    .foregroundStyle(GameColor.textSecondary)

                Button {
                    controller.passGuessing()
                } label: {
                    Text("PASS")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(GameColor.buttonGray)
                        .foregroundStyle(GameColor.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(.vertical, 10)
        .background(GameColor.panelBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 10)
    }
}
