//
//  PlaybackControlsView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI

struct PlaybackControlsView: View {
    @Bindable var playbackState: PlaybackState
    let onPlay: () -> Void
    let onPause: () -> Void
    let onSeek: (Int) -> Void
    let onAdjustSpeed: (Int) -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Progress indicator
            HStack {
                Text("\(playbackState.currentIndex + 1) / \(playbackState.words.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Progress bar
            if !playbackState.words.isEmpty {
                ProgressView(value: Double(playbackState.currentIndex), total: Double(playbackState.words.count - 1))
                    .progressViewStyle(.linear)
                    .frame(height: 4)
            }

            // Play/Pause button
            Button(action: {
                if playbackState.isPlaying {
                    onPause()
                } else {
                    onPlay()
                }
            }) {
                Image(systemName: playbackState.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 24))
                    .frame(width: 60, height: 60)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(Circle())
            }

            // WPM slider
            VStack(spacing: 8) {
                Text("Speed: \(playbackState.wpm) WPM")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Slider(value: Binding(
                    get: { Double(playbackState.wpm) },
                    set: { onAdjustSpeed(Int($0)) }
                ), in: 100...600, step: 50)
            }

            // Seek slider
            if !playbackState.words.isEmpty {
                VStack(spacing: 8) {
                    Text("Position")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Slider(value: Binding(
                        get: { Double(playbackState.currentIndex) },
                        set: { onSeek(Int($0)) }
                    ), in: 0...Double(max(0, playbackState.words.count - 1)), step: 1)
                }
            }
        }
        .padding()
    }
}

#Preview {
    PlaybackControlsView(
        playbackState: {
            let state = PlaybackState()
            state.words = Array(repeating: "word", count: 100)
            state.currentIndex = 10
            return state
        }(),
        onPlay: {},
        onPause: {},
        onSeek: { _ in },
        onAdjustSpeed: { _ in }
    )
}
