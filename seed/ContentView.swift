//
//  ContentView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = RSVPViewModel()

    var body: some View {
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
        .onAppear {
            viewModel.loadText("Sample RSVP text for testing smooth playback at various speeds and word lengths.")
        }
    }
}

#Preview {
    ContentView()
}
