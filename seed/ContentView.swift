//
//  ContentView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = RSVPViewModel()
    @State private var hasLoadedText = false
    @State private var inputText = ""

    var body: some View {
        if hasLoadedText {
            VStack(spacing: 32) {
                Spacer()

                RSVPDisplayView(playbackState: viewModel.playbackState)

                Spacer()

                PlaybackControlsView(
                    playbackState: viewModel.playbackState,
                    onPlay: viewModel.play,
                    onPause: viewModel.pause,
                    onSeek: viewModel.seek,
                    onAdjustSpeed: viewModel.adjustSpeed
                )
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        resetToInput()
                    }
                }
            }
        } else {
            TextInputView(text: $inputText) { validatedText in
                viewModel.loadText(validatedText)
                hasLoadedText = true
            }
        }
    }

    private func resetToInput() {
        hasLoadedText = false
        inputText = ""
        viewModel.playbackState.pause()
    }
}

#Preview {
    ContentView()
}
