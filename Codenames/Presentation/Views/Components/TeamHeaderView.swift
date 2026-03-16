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
        VStack(spacing: 6) {
            Text("Turn \(game.turnNumber)")
            Text("Active: \(game.turnState.activeTeam.rawValue.uppercased()) • Phase: \(game.turnState.turnPhase.rawValue)")
                .font(.subheadline)

            HStack {
                Text("Red: \(game.red.score)/\(game.red.targetScore)")
                Spacer()
                Text("Blue: \(game.blue.score)/\(game.blue.targetScore)")
            }
            .padding(.horizontal)
            .font(.subheadline)
        }
    }
}
