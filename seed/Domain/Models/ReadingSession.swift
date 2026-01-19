//
//  ReadingSession.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import Foundation

struct ReadingSession: Codable, Identifiable {
    let id: UUID
    let startTime: Date
    let endTime: Date
    let wordCount: Int
    let wpm: Int
    let textSource: String

    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }

    var formattedDuration: String {
        let totalSeconds = Int(duration)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init(id: UUID = UUID(), startTime: Date, endTime: Date, wordCount: Int, wpm: Int, textSource: String) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.wordCount = wordCount
        self.wpm = wpm
        self.textSource = String(textSource.prefix(50))
    }
}
