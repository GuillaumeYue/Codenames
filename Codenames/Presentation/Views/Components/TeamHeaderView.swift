//
//  TeamHeaderView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct TeamHeaderView: View {
    let game: Game

    var body: some View {
        HStack(spacing: 0) {
            // Blue team score
            teamScoreBadge(
                label: "BLUE",
                score: game.blue.score,
                target: game.blue.targetScore,
                color: GameColor.teamBlue,
                isActive: game.turnState.activeTeam == .blue
            )

            Spacer()

            // Turn indicator
            VStack(spacing: 2) {
                Text("TURN \(game.turnNumber)")
                    .font(.caption2.bold())
                    .tracking(1)
                    .foregroundStyle(GameColor.textSecondary)
            }

            Spacer()

            // Red team score
            teamScoreBadge(
                label: "RED",
                score: game.red.score,
                target: game.red.targetScore,
                color: GameColor.teamRed,
                isActive: game.turnState.activeTeam == .red
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(GameColor.panelBackground)
    }

    private func teamScoreBadge(label: String, score: Int, target: Int, color: Color, isActive: Bool) -> some View {
        HStack(spacing: 8) {
            VStack(spacing: 2) {
                Text(label)
                    .font(.caption.bold())
                    .tracking(1)
                Text("\(score)/\(target)")
                    .font(.title3.bold())
            }
            .foregroundStyle(.white)
            .frame(minWidth: 70)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isActive ? Color.white : Color.clear, lineWidth: 2)
            )
        }
    }
}
