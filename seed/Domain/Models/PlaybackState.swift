//
//  PlaybackState.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import Foundation
import Observation

@Observable
class PlaybackState {
    var words: [String] = []
    var currentIndex: Int = 0
    var isPlaying: Bool = false
    var wpm: Int = 300

    var progress: Double {
        guard !words.isEmpty else { return 0.0 }
        return Double(currentIndex) / Double(words.count)
    }

    func play() {
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }

    func seek(to index: Int) {
        guard index >= 0 && index < words.count else { return }
        currentIndex = index
    }

    func adjustSpeed(wpm newWpm: Int) {
        wpm = max(50, min(1000, newWpm))
    }
}
