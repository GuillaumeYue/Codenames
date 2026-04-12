//
//  AppMetadata.swift
//  Codenames
//
//  Iteration 3 - from UC-11 View About Information
//  Iteration 3 - from CD-CO39 displayAboutInfo
//  Iteration 3 - from Class Diagram (AppMetadata)
//

import Foundation

// Iteration 3 - from Class Diagram (AppMetadata)
struct AppMetadata {
    let bundleId: String                // Class Diagram
    let buildNumber: String             // Class Diagram
    let version: String                 // Class Diagram

    // Iteration 3 - from Class Diagram, CD-CO39
    static func fromBundle() -> AppMetadata {
        let bundleId = Bundle.main.bundleIdentifier ?? "com.codenames.app"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return AppMetadata(bundleId: bundleId, buildNumber: build, version: version)
    }
}
