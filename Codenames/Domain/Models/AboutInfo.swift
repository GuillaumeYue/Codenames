//
//  AboutInfo.swift
//  Codenames
//
//  Iteration 3 - from UC-11 View About Information
//  Iteration 3 - from SSD-11 View About Information
//  Iteration 3 - from CD-CO39 displayAboutInfo
//  Iteration 3 - from Class Diagram (AboutInfo)
//

import Foundation

// Iteration 3 - from Class Diagram (AboutInfo), Domain Model
struct AboutInfo {
    let appName: String                 // Class Diagram
    let version: String                 // Class Diagram
    let buildNumber: String             // Class Diagram
    let credits: String                 // Class Diagram
    let copyright: String              // Class Diagram
    let legalNotice: String             // Class Diagram

    // Iteration 3 - from Class Diagram (getFormattedVersion), CD-CO39 step 1.1
    func getFormattedVersion() -> String {
        version
    }

    // Iteration 3 - from Class Diagram (buildNumber)
    func getFormattedBuild() -> String {
        buildNumber
    }
}
