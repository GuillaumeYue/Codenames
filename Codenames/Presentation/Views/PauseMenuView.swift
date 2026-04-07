//
//  PauseMenuView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct PauseMenuView: View {

    @ObservedObject var controller: GameController

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("PAUSED")
                    .font(.system(size: 28, weight: .black))
                    .tracking(4)
                    .foregroundStyle(GameColor.textPrimary)
                    .padding(.bottom, 8)

                // SSD-8 message 2.1: resumeGame()
                Button {
                    controller.resumeGame()
                } label: {
                    Text("RESUME")
                        .font(.title3.bold())
                        .tracking(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(GameColor.buttonGreen)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // SSD-8 message 2.3: openHowToPlay()
                Button {
                    controller.openHowToPlay()
                } label: {
                    Text("HOW TO PLAY")
                        .font(.title3)
                        .tracking(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(GameColor.buttonGray)
                        .foregroundStyle(GameColor.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // SSD-8 message 2.5: openSettings()
                Button {
                    controller.openSettings()
                } label: {
                    Text("SETTINGS")
                        .font(.title3)
                        .tracking(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(GameColor.buttonGray)
                        .foregroundStyle(GameColor.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // SSD-8 message 2.7: requestQuitGame()
                Button {
                    controller.requestQuitGame()
                } label: {
                    Text("QUIT GAME")
                        .font(.title3)
                        .tracking(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(GameColor.teamRed.opacity(0.2))
                        .foregroundStyle(GameColor.teamRed)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(28)
            .background(GameColor.panelBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 40)
        }
    }
}
