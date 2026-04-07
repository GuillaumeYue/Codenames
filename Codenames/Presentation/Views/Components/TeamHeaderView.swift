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
            // Blue team score badge
            teamScoreBadge(
                label: "BLUE",
                score: game.blue.score,
                target: game.blue.targetScore,
                color: GameColor.teamBlue,
                isActive: game.turnState.activeTeam == .blue
            )

            Spacer()

            // Turn indicator — compact single line
            Text("TURN \(game.turnNumber)")
                .font(.caption2.bold())
                .tracking(1)
                .foregroundStyle(GameColor.textSecondary)

            Spacer()

            // Red team score badge
            teamScoreBadge(
                label: "RED",
                score: game.red.score,
                target: game.red.targetScore,
                color: GameColor.teamRed,
                isActive: game.turnState.activeTeam == .red
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(GameColor.panelBackground)
    }

    private func teamScoreBadge(label: String, score: Int, target: Int, color: Color, isActive: Bool) -> some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.caption2.bold())
                .tracking(1)
            Text("\(score)/\(target)")
                .font(.subheadline.bold())
        }
        .foregroundStyle(.white)
        .padding(.vertical, 6)
        .padding(.horizontal, 14)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isActive ? Color.white : Color.clear, lineWidth: 2)
        )
    }
}
