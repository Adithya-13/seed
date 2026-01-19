//
//  RSVPViewModel.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import Foundation
import Observation

@Observable
class RSVPViewModel {
    let playbackState: PlaybackState
    private let engine: RSVPEngine
    let sessionStore: SessionStore

    var sessionCompleted: Bool = false
    var lastSession: ReadingSession?

    private var sessionStartTime: Date?
    private var currentText: String = ""

    init(sessionStore: SessionStore = SessionStore()) {
        self.playbackState = PlaybackState()
        self.sessionStore = sessionStore
        self.engine = RSVPEngine(playbackState: playbackState)
        self.engine.onCompletion = { [weak self] in
            self?.checkCompletion()
        }
    }

    func loadText(_ text: String) {
        let tokens = WordTokenizer.tokenize(text)
        playbackState.words = tokens
        playbackState.currentIndex = 0
        playbackState.isPlaying = false
        currentText = text
        sessionStartTime = nil
        sessionCompleted = false
    }

    func play() {
        if sessionStartTime == nil {
            sessionStartTime = Date()
        }
        playbackState.play()
        engine.start()
    }

    func pause() {
        playbackState.pause()
        engine.stop()
    }

    func seek(to index: Int) {
        playbackState.seek(to: index)
    }

    func adjustSpeed(wpm: Int) {
        playbackState.adjustSpeed(wpm: wpm)
    }

    func checkCompletion() {
        guard playbackState.currentIndex == playbackState.words.count - 1,
              !playbackState.isPlaying,
              let startTime = sessionStartTime,
              !sessionCompleted else {
            return
        }

        let endTime = Date()
        let session = ReadingSession(
            startTime: startTime,
            endTime: endTime,
            wordCount: playbackState.words.count,
            wpm: playbackState.wpm,
            textSource: currentText
        )

        sessionStore.addSession(session)
        lastSession = session
        sessionCompleted = true
    }
}
