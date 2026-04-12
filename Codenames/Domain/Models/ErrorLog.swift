//
//  ErrorLog.swift
//  Codenames
//
//  Iteration 3 - from UC-12 Handle Error Recovery
//  Iteration 3 - from Class Diagram (ErrorLog)
//

import Foundation

// Iteration 3 - from Class Diagram (ErrorLog)
final class ErrorLog {
    private(set) var entries: [String] = []     // Class Diagram (entries : List)
    private(set) var createdAt: Date = Date()   // Class Diagram

    // Iteration 3 - from Class Diagram (append)
    func append(_ entry: String) {
        entries.append("[\(Date())] \(entry)")
    }

    // Iteration 3 - from Class Diagram (log)
    func log(_ message: String) {
        append(message)
    }

    // Iteration 3 - from Class Diagram (clear)
    func clear() {
        entries.removeAll()
    }
}
