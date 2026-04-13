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
    @FocusState private var focusedField: Field?

    private enum Field { case clueWord, clueNumber }

    var body: some View {
        ZStack {
            GameColor.background
                .ignoresSafeArea()
                .onTapGesture { focusedField = nil }

            if let game = controller.currentGame {
                let canSelectCards =
                    game.turnState.turnPhase == .operative &&
                    !game.isGameOver &&
                    (game.turnState.guessesRemaining == -1 || game.turnState.guessesRemaining > 0)

                VStack(spacing: 4) {
                    // Compact header + phase in one row
                    HStack(spacing: 0) {
                        TeamHeaderView(game: game)
                    }

                    // Phase input area — compact
                    if game.turnState.turnPhase == .spymaster {
                        spymasterPanel(game: game)
                    } else {
                        operativePanel(game: game)
                    }

                    // Card grid — fills remaining space
                    GeometryReader { geo in
                        let spacing: CGFloat = 5
                        let rows: CGFloat = 5
                        let availableHeight = geo.size.height
                        let cardHeight = (availableHeight - spacing * (rows - 1)) / rows

                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: 5),
                            spacing: spacing
                        ) {
                            ForEach(game.board.cards) { card in
                                CardCellView(card: card, isInteractive: canSelectCards && !card.isRevealed) {
                                    focusedField = nil
                                    controller.selectCard(cardId: card.id)
                                }
                                .frame(height: cardHeight)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
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
                        .font(.title3)
                        .foregroundStyle(GameColor.textSecondary)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(GameColor.panelBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private func spymasterPanel(game: Game) -> some View {
        HStack(spacing: 8) {
            Text("SPYMASTER")
                .font(.system(size: 10, weight: .bold))
                .tracking(1)
                .foregroundStyle(
                    game.turnState.activeTeam == .red ? GameColor.teamRed : GameColor.teamBlue
                )
                .frame(width: 76)

            TextField("Clue Word", text: $clueWord)
                .textFieldStyle(.plain)
                .font(.subheadline)
                .padding(8)
                .background(GameColor.cardPanel)
                .foregroundStyle(GameColor.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .focused($focusedField, equals: .clueWord)
                .submitLabel(.next)
                .onSubmit { focusedField = .clueNumber }

            TextField("#", text: $clueNumberText)
                .textFieldStyle(.plain)
                .font(.subheadline)
                .padding(8)
                .frame(width: 44)
                .background(GameColor.cardPanel)
                .foregroundStyle(GameColor.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .clueNumber)
                .submitLabel(.done)
                .onSubmit { focusedField = nil }

            Button {
                focusedField = nil
                let n = Int(clueNumberText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 1
                controller.submitClue(clueWord: clueWord, clueNumber: n)
                clueWord = ""
                clueNumberText = "1"
            } label: {
                Text("SUBMIT")
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(GameColor.buttonGreen)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            if let err = controller.errorMessage {
                Text(err)
                    .font(.caption2)
                    .foregroundStyle(GameColor.teamRed)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(GameColor.panelBackground)
    }

    private func operativePanel(game: Game) -> some View {
        HStack(spacing: 12) {
            Text("OPERATIVE")
                .font(.system(size: 10, weight: .bold))
                .tracking(1)
                .foregroundStyle(
                    game.turnState.activeTeam == .red ? GameColor.teamRed : GameColor.teamBlue
                )

            if let clue = game.turnState.currentClue {
                Text(clue.word.uppercased())
                    .font(.subheadline.bold())
                    .foregroundStyle(GameColor.textPrimary)

                Text(clue.isUnlimited ? "∞" : "\(clue.number)")
                    .font(.subheadline.bold())
                    .foregroundStyle(
                        game.turnState.activeTeam == .red ? GameColor.teamRed : GameColor.teamBlue
                    )
            }

            Spacer()

            Text("Guesses: \(game.turnState.guessesRemaining == -1 ? "∞" : "\(game.turnState.guessesRemaining)")")
                .font(.caption)
                .foregroundStyle(GameColor.textSecondary)

            Button {
                controller.passGuessing()
            } label: {
                Text("PASS")
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(GameColor.buttonGray)
                    .foregroundStyle(GameColor.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(GameColor.panelBackground)
    }
}
