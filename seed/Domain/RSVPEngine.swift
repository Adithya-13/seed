//
//  RSVPEngine.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import Foundation
import QuartzCore

class RSVPEngine {
    let playbackState: PlaybackState
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var accumulatedTime: TimeInterval = 0

    private var baseInterval: TimeInterval {
        60.0 / Double(playbackState.wpm)
    }

    private var currentWordDuration: TimeInterval {
        guard playbackState.currentIndex < playbackState.words.count else {
            return baseInterval
        }

        let word = playbackState.words[playbackState.currentIndex]
        let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
        var duration = baseInterval

        // Long word adjustment: +50% for 8+ chars
        if cleanWord.count >= 8 {
            duration *= 1.5
        }

        // Sentence-ending punctuation: +100%
        if word.hasSuffix(".") || word.hasSuffix("!") || word.hasSuffix("?") {
            duration *= 2.0
        }

        return duration
    }

    init(playbackState: PlaybackState) {
        self.playbackState = playbackState
    }

    func start() {
        guard displayLink == nil else { return }

        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
        lastTimestamp = 0
        accumulatedTime = 0
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
        lastTimestamp = 0
        accumulatedTime = 0
    }

    @objc private func update(displayLink: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = displayLink.timestamp
            return
        }

        let deltaTime = displayLink.timestamp - lastTimestamp
        lastTimestamp = displayLink.timestamp
        accumulatedTime += deltaTime

        if accumulatedTime >= currentWordDuration {
            advanceWord()
            accumulatedTime = 0
        }
    }

    private func advanceWord() {
        guard playbackState.currentIndex < playbackState.words.count - 1 else {
            playbackState.pause()
            stop()
            return
        }

        playbackState.currentIndex += 1
    }
}
