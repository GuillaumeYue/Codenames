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
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("PAUSED")
                    .font(.largeTitle.bold())

                // SSD-8 message 2.1: resumeGame()
                Button {
                    controller.resumeGame()
                } label: {
                    Text("Resume")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // SSD-8 message 2.3: openHowToPlay()
                Button {
                    controller.openHowToPlay()
                } label: {
                    Text("How to Play")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // SSD-8 message 2.5: openSettings()
                Button {
                    controller.openSettings()
                } label: {
                    Text("Settings")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // SSD-8 message 2.7: requestQuitGame()
                Button {
                    controller.requestQuitGame()
                } label: {
                    Text("Quit Game")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.red.opacity(0.15))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(32)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 40)
        }
    }
}
