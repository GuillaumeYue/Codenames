//
//  HowToPlayView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct HowToPlayView: View {

    let controller: GameController
    let guide: HelpGuide

    var body: some View {
        NavigationStack {
            ZStack {
                GameColor.background
                    .ignoresSafeArea()

                // UC-06 SSD-6 loop: scrollContent(direction, delta)
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        sectionView(title: "Objective", text: guide.objectiveText)
                        sectionView(title: "Roles", text: guide.roleDescription)
                        sectionView(title: "Turn Structure", text: guide.turnStructure)
                        sectionView(title: "Win Condition", text: guide.winConditionText)
                    }
                    .padding()
                }
            }
            .navigationTitle("How to Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(GameColor.panelBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // UC-06 SSD-6 message 3: navigateBack()
                    Button("Done") { controller.navigateBack() }
                        .foregroundStyle(GameColor.teamBlue)
                }
            }
        }
    }

    private func sectionView(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(GameColor.textPrimary)
            Text(text)
                .font(.body)
                .foregroundStyle(GameColor.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(GameColor.panelBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
