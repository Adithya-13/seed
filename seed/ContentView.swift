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
    var settings: AppSettings

    var body: some View {
        if hasLoadedText {
            VStack(spacing: 32) {
                Spacer()

                RSVPDisplayView(playbackState: viewModel.playbackState, settings: settings)

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
            .preferredColorScheme(settings.colorScheme)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView(settings: settings)
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        resetToInput()
                    }
                }
            }
        } else {
            InputSourcePicker { validatedText in
                viewModel.loadText(validatedText)
                hasLoadedText = true
            }
        }
    }

    private func resetToInput() {
        hasLoadedText = false
        viewModel.playbackState.pause()
    }
}

#Preview {
    ContentView(settings: AppSettings())
}
