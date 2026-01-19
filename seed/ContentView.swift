//
//  ContentView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var sessionStore = SessionStore()
    @State private var viewModel: RSVPViewModel?
    @State private var hasLoadedText = false
    @State private var showFocusModeHint = false
    var settings: AppSettings

    private var readingBackground: Color {
        settings.colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color(red: 0.98, green: 0.97, blue: 0.95)
    }

    var body: some View {
        if hasLoadedText, let vm = viewModel {
            if settings.focusMode {
                ZStack {
                    readingBackground.ignoresSafeArea()
                    RSVPDisplayView(playbackState: vm.playbackState, settings: settings)
                        .onTapGesture {
                            if vm.playbackState.isPlaying {
                                vm.pause()
                            } else {
                                vm.play()
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
                .sheet(isPresented: Binding(
                    get: { vm.sessionCompleted },
                    set: { vm.sessionCompleted = $0 }
                )) {
                    if let session = vm.lastSession {
                        CompletionStatsView(session: session) {
                            vm.sessionCompleted = false
                        }
                    }
                }
            } else {
                TabView {
                    NavigationView {
                        InputSourcePicker { validatedText in
                            viewModel?.loadText(validatedText)
                        }
                    }
                    .tabItem {
                        Label("Input", systemImage: "doc.text")
                    }

                    NavigationView {
                        VStack(spacing: 32) {
                            Spacer()

                            RSVPDisplayView(playbackState: vm.playbackState, settings: settings)

                            Spacer()

                            PlaybackControlsView(
                                playbackState: vm.playbackState,
                                onPlay: vm.play,
                                onPause: vm.pause,
                                onSeek: vm.seek,
                                onAdjustSpeed: vm.adjustSpeed
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
                    }
                    .tabItem {
                        Label("Reading", systemImage: "play.circle")
                    }

                    HistoryView(sessionStore: sessionStore)
                        .tabItem {
                            Label("History", systemImage: "chart.line.uptrend.xyaxis")
                        }
                }
                .sheet(isPresented: Binding(
                    get: { vm.sessionCompleted },
                    set: { vm.sessionCompleted = $0 }
                )) {
                    if let session = vm.lastSession {
                        CompletionStatsView(session: session) {
                            vm.sessionCompleted = false
                        }
                    }
                }
            }
        } else {
            InputSourcePicker { validatedText in
                let vm = RSVPViewModel(sessionStore: sessionStore)
                vm.loadText(validatedText)
                viewModel = vm
                hasLoadedText = true
            }
        }
    }

    private func resetToInput() {
        hasLoadedText = false
        viewModel?.playbackState.pause()
    }
}

#Preview {
    ContentView(settings: AppSettings())
}
