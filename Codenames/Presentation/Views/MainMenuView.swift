//
//  MainMenuView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct MainMenuView: View {

    @ObservedObject var controller: GameController

    var body: some View {
        NavigationStack {
            ZStack {
                GameColor.background
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // Title
                    VStack(spacing: 8) {
                        Text("CODENAMES")
                            .font(.system(size: 46, weight: .black))
                            .tracking(6)
                            .foregroundStyle(GameColor.textPrimary)

                        // Team color accent bar
                        HStack(spacing: 0) {
                            GameColor.teamRed
                            GameColor.teamBlue
                        }
                        .frame(height: 4)
                        .clipShape(Capsule())
                        .padding(.horizontal, 80)
                    }

                    // Menu buttons
                    VStack(spacing: 14) {
                        ForEach(controller.mainMenuOptions) { option in
                            Button {
                                controller.selectMenuOption(option: option)
                            } label: {
                                Text(option.optionName.uppercased())
                                    .font(.title3.bold())
                                    .tracking(1)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        option.destination == "gameBoard"
                                            ? GameColor.buttonGreen
                                            : GameColor.buttonGray
                                    )
                                    .foregroundStyle(GameColor.textPrimary)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .padding(.horizontal, 40)

                    Spacer()
                    Spacer()
                }
            }
        }
    }
}
