//
//  AboutView.swift
//  Codenames
//
//  Iteration 3 - from UC-11 View About Information
//  Iteration 3 - from SSD-11 View About Information
//  Iteration 3 - from CD-CO38 openAbout
//  Iteration 3 - from CD-CO39 displayAboutInfo
//  Iteration 3 - from Class Diagram (AboutScreen)
//

import SwiftUI

// Iteration 3 - from Class Diagram (AboutScreen), UC-11
struct AboutView: View {

    let controller: GameController
    @ObservedObject var viewModel: AboutViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                GameColor.background
                    .ignoresSafeArea()

                // SSD-11 loop: scrollContent(direction, delta)
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if let info = viewModel.info {
                            // Iteration 3 - from CD-CO39 displayAboutInfo (render version, credits, legal)
                            sectionView(
                                title: "Application",
                                text: "\(info.appName)\nVersion \(info.getFormattedVersion()) (Build \(info.getFormattedBuild()))"
                            )
                            sectionView(title: "Credits", text: info.credits)
                            sectionView(title: "Course", text: "Information System Implementation\n420-MP6-AS — Winter 2026")
                            sectionView(title: "Copyright", text: info.copyright)
                            sectionView(title: "Legal Notice", text: info.legalNotice)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(GameColor.panelBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // SSD-11 message 5: navigateBack()
                    Button("Done") { controller.navigateBack() }
                        .foregroundStyle(GameColor.teamBlue)
                }
            }
            .onAppear {
                viewModel.openAbout()
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
