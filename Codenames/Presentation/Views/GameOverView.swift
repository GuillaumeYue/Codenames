//
//  GameOverView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct GameOverView: View {

    @ObservedObject var controller: GameController

    var body: some View {
        VStack(spacing: 16) {
            Text("Game Over").font(.largeTitle).bold()
            Text(controller.currentGame?.outcome.rawValue ?? "Unknown Result")

            if let g = controller.currentGame {
                Text("Turns: \(g.turnNumber)")
                Text("Red: \(g.red.score)/\(g.red.targetScore) • Blue: \(g.blue.score)/\(g.blue.targetScore)")
            }

            Button("Play Again") { controller.startGameSession() }
                .buttonStyle(.borderedProminent)

            Button("Main Menu") { controller.displayMainMenu() }
                .buttonStyle(.bordered)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
