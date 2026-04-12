//
//  AboutViewModel.swift
//  Codenames
//
//  Iteration 3 - from UC-11 View About Information
//  Iteration 3 - from SSD-11 View About Information
//  Iteration 3 - from CD-CO38 openAbout
//  Iteration 3 - from CD-CO39 displayAboutInfo
//  Iteration 3 - from Class Diagram (AboutViewModel)
//

import Foundation
import Combine

// Iteration 3 - from Class Diagram (AboutViewModel)
final class AboutViewModel: ObservableObject {
    @Published var info: AboutInfo?                 // Class Diagram (info : AboutInfo, includes 1)

    // Iteration 3 - from Class Diagram (openAbout), CD-CO38
    func openAbout() {
        fetchAboutInfo()
    }

    // Iteration 3 - from Class Diagram (fetchAboutInfo), CD-CO39
    func fetchAboutInfo() {
        let metadata = AppMetadata.fromBundle()     // CD-CO39 (AppMetadata available from bundle)
        info = AboutInfo(
            appName: "Codenames",
            version: metadata.version,              // CD-CO39 step 1.1 (getVersion)
            buildNumber: metadata.buildNumber,
            credits: "Antonio Moriello, Han Yue, Apostolos Tsouroupakis",   // CD-CO39 step 1.2 (getCredits)
            copyright: "© 2026 Codenames Team",
            legalNotice: "Codenames is based on the board game by Vlaada Chvátil. This application was developed for Information System Implementation (420-MP6-AS) - Winter 2026."
        )
    }

    // Iteration 3 - from Class Diagram (dismiss)
    func dismiss() {
        info = nil
    }
}
