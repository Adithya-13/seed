//
//  seedApp.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI

@main
struct seedApp: App {
    @State private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            if settings.hasCompletedOnboarding {
                NavigationStack {
                    ContentView(settings: settings)
                }
            } else {
                OnboardingView(settings: settings) {
                    // Completion triggers view refresh via settings change
                }
            }
        }
    }
}
