//
//  RSVPDisplayView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI

struct RSVPDisplayView: View {
    @Bindable var playbackState: PlaybackState
    var settings: AppSettings

    private var readingBackground: Color {
        settings.colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color(red: 0.98, green: 0.97, blue: 0.95)
    }

    private var readingText: Color {
        settings.colorScheme == .dark ? Color(red: 0.9, green: 0.88, blue: 0.85) : Color(red: 0.15, green: 0.15, blue: 0.2)
    }

    var body: some View {
        VStack {
            if !playbackState.words.isEmpty && playbackState.currentIndex < playbackState.words.count {
                Text(attributedWord)
                    .font(.system(size: settings.fontSize, weight: .medium, design: .default))
                    .frame(minWidth: 300, minHeight: 80)
                    .foregroundStyle(readingText)
            } else {
                Text("")
                    .font(.system(size: settings.fontSize, weight: .medium, design: .default))
                    .frame(minWidth: 300, minHeight: 80)
            }
        }
    }

    private var attributedWord: AttributedString {
        let word = playbackState.words[playbackState.currentIndex]
        var attributed = AttributedString(word)

        if let range = SmartAnchor.anchorRange(for: word) {
            let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
            if let attrRange = attributed.range(of: cleanWord) {
                let anchorLength = cleanWord.distance(from: range.lowerBound, to: range.upperBound)
                let anchorEnd = attributed.index(attrRange.lowerBound, offsetByCharacters: anchorLength)
                attributed[attrRange.lowerBound..<anchorEnd].font = .system(size: settings.fontSize, weight: .bold, design: .default)
            }
        }

        return attributed
    }
}

#Preview {
    RSVPDisplayView(
        playbackState: {
            let state = PlaybackState()
            state.words = ["reading", "test", "smart", "anchoring"]
            state.currentIndex = 0
            return state
        }(),
        settings: AppSettings()
    )
}
