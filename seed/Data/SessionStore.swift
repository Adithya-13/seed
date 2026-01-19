//
//  SessionStore.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import Foundation
import SwiftUI
import Observation

@Observable
class SessionStore {
    @ObservationIgnored @AppStorage("sessionsData") private var sessionsData: String = "[]"

    var sessions: [ReadingSession] {
        guard let data = sessionsData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([ReadingSession].self, from: data) else {
            return []
        }
        return decoded
    }

    func addSession(_ session: ReadingSession) {
        var currentSessions = sessions
        currentSessions.append(session)

        if currentSessions.count > 50 {
            currentSessions.removeFirst(currentSessions.count - 50)
        }

        if let encoded = try? JSONEncoder().encode(currentSessions),
           let jsonString = String(data: encoded, encoding: .utf8) {
            sessionsData = jsonString
        }
    }

    func recentSessions(limit: Int) -> [ReadingSession] {
        let allSessions = sessions
        return Array(allSessions.suffix(limit))
    }
}
