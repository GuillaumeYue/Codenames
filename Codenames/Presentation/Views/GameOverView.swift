//
//  GameOverView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI
import Combine

struct GameOverView: View {

    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Game Over").font(.largeTitle).bold()
            Text(vm.game?.outcome ?? "Unknown Result")

            if let g = vm.game {
                Text("Turns: \(g.turnNumber)")
                Text("Red: \(g.red.score) • Blue: \(g.blue.score)")
            }

            Button("Play Again") { vm.startNewGame() }
                .buttonStyle(.borderedProminent)

            Button("Main Menu") { vm.backToMenu() }
                .buttonStyle(.bordered)
        }
        .padding()
    }
}
