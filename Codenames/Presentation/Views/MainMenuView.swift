//
//  MainMenuView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct MainMenuView: View {

    @ObservedObject var vm: GameViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("CODENAMES")
                    .font(.largeTitle).bold()

                Button("Start Game") {
                    vm.startNewGame()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink(
                    destination: GameBoardView(vm: vm),
                    isActive: Binding(
                        get: { vm.game != nil },
                        set: { _ in }
                    )
                ) { EmptyView() }
            }
            .padding()
        }
    }
}
