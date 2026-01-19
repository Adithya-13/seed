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
    @State private var showFocusModeHint = false
    var settings: AppSettings

    private var readingBackground: Color {
        settings.colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color(red: 0.98, green: 0.97, blue: 0.95)
    }

    var body: some View {
        if hasLoadedText {
            if settings.focusMode {
                ZStack {
                    readingBackground.ignoresSafeArea()
                    RSVPDisplayView(playbackState: viewModel.playbackState, settings: settings)
                        .onTapGesture {
                            if viewModel.playbackState.isPlaying {
                                viewModel.pause()
                            } else {
                                viewModel.play()
                            }
                        }
                        .onLongPressGesture(minimumDuration: 1.0) {
                            settings.focusMode = false
                        }

                    if showFocusModeHint {
                        VStack(spacing: 12) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 40))
                            Text("Tap: Play/Pause")
                                .font(.headline)
                            Text("Long press: Exit")
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                        .padding(24)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(16)
                        .transition(.opacity)
                    }
                }
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
                .onChange(of: settings.focusMode) { _, newValue in
                    if newValue {
                        showFocusModeHint = true
                        Task {
                            try? await Task.sleep(nanoseconds: 3_000_000_000)
                            withAnimation {
                                showFocusModeHint = false
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.sessionCompleted) {
                    if let session = viewModel.lastSession {
                        CompletionStatsView(session: session) {
                            viewModel.sessionCompleted = false
                        }
                    }
                }
            } else {
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
                            Image(systemName: "gearshape.fill")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            resetToInput()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                    }
                }
                .sheet(isPresented: $viewModel.sessionCompleted) {
                    if let session = viewModel.lastSession {
                        CompletionStatsView(session: session) {
                            viewModel.sessionCompleted = false
                        }
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
