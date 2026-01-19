//
//  OnboardingView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI

struct OnboardingView: View {
    @Bindable var settings: AppSettings
    let onComplete: () -> Void

    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $currentPage) {
                WelcomePage()
                    .tag(0)

                RSVPDemoPage(settings: settings)
                    .tag(1)

                BenefitsPage()
                    .tag(2)

                GetStartedPage(onComplete: handleCompletion)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            if currentPage < 3 {
                Button("Skip") {
                    handleCompletion()
                }
                .padding()
            }
        }
    }

    private func handleCompletion() {
        settings.completeOnboarding()
        onComplete()
    }
}

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "text.viewfinder")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text("Welcome to Seed")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Read faster with RSVP training")
                .font(.title3)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
    }
}

struct RSVPDemoPage: View {
    var settings: AppSettings
    @State private var playbackState = PlaybackState()
    @State private var engine: RSVPEngine?

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("How RSVP Works")
                .font(.largeTitle)
                .fontWeight(.bold)

            RSVPDisplayView(playbackState: playbackState, settings: settings)
                .frame(height: 120)

            Text("Words appear one at a time.\nNo eye movement needed.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .onAppear {
            setupDemo()
        }
        .onDisappear {
            engine?.stop()
        }
    }

    private func setupDemo() {
        playbackState.words = ["RSVP", "eliminates", "eye", "movement", "and", "increases", "reading", "speed"]
        playbackState.currentIndex = 0
        playbackState.wpm = 300

        let rsvpEngine = RSVPEngine(playbackState: playbackState)
        engine = rsvpEngine

        playbackState.play()
        rsvpEngine.start()

        Task {
            try? await Task.sleep(for: .seconds(Double(playbackState.words.count) * 60.0 / 300.0))
            playbackState.currentIndex = 0
            playbackState.play()
            rsvpEngine.start()
        }
    }
}

struct BenefitsPage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Why RSVP?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 25) {
                BenefitRow(icon: "eye.slash", title: "Eliminate saccades", description: "No more back-and-forth eye movements")

                BenefitRow(icon: "sparkles", title: "Reduce distractions", description: "Single-word focus prevents mind wandering")

                BenefitRow(icon: "target", title: "Increase focus", description: "Train your brain to absorb information faster")
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct GetStartedPage: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)

            Text("You're all set!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Start your RSVP reading journey")
                .font(.title3)
                .foregroundStyle(.secondary)

            Button(action: onComplete) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView(settings: AppSettings()) { }
}
