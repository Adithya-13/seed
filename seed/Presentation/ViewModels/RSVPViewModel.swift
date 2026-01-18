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

    init() {
        self.playbackState = PlaybackState()
        self.engine = RSVPEngine(playbackState: playbackState)
    }

    func loadText(_ text: String) {
        let tokens = WordTokenizer.tokenize(text)
        playbackState.words = tokens
        playbackState.currentIndex = 0
        playbackState.isPlaying = false
    }

    func play() {
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
}
