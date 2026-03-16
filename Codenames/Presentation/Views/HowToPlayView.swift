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
            .navigationTitle("How to Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // UC-06 SSD-6 message 3: navigateBack()
                    Button("Done") { controller.navigateBack() }
                }
            }
        }
    }

    private func sectionView(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}
