//
//  GameOverView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct GameOverView: View {

    @ObservedObject var controller: GameController

    private var winnerColor: Color {
        guard let outcome = controller.currentGame?.outcome else { return GameColor.textPrimary }
        switch outcome {
        case .redWins: return GameColor.teamRed
        case .blueWins: return GameColor.teamBlue
        case .none: return GameColor.textSecondary
        }
    }

    var body: some View {
        ZStack {
            GameColor.background
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Text("GAME OVER")
                    .font(.system(size: 36, weight: .black))
                    .tracking(4)
                    .foregroundStyle(GameColor.textPrimary)

                Text(controller.currentGame?.outcome.rawValue ?? "Unknown Result")
                    .font(.title2.bold())
                    .foregroundStyle(winnerColor)

                if let g = controller.currentGame {
                    VStack(spacing: 12) {
                        Text("Turns: \(g.turnNumber)")
                            .foregroundStyle(GameColor.textSecondary)

                        HStack(spacing: 24) {
                            teamResultBadge(label: "RED", score: g.red.score, target: g.red.targetScore, color: GameColor.teamRed)
                            teamResultBadge(label: "BLUE", score: g.blue.score, target: g.blue.targetScore, color: GameColor.teamBlue)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(GameColor.panelBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                VStack(spacing: 12) {
                    Button {
                        controller.startGameSession()
                    } label: {
                        Text("PLAY AGAIN")
                            .font(.title3.bold())
                            .tracking(1)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(GameColor.buttonGreen)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button {
                        controller.displayMainMenu()
                    } label: {
                        Text("MAIN MENU")
                            .font(.title3)
                            .tracking(1)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(GameColor.buttonGray)
                            .foregroundStyle(GameColor.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 40)

                Spacer()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func teamResultBadge(label: String, score: Int, target: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption.bold())
                .tracking(1)
            Text("\(score)/\(target)")
                .font(.title.bold())
        }
        .foregroundStyle(.white)
        .frame(minWidth: 80)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
