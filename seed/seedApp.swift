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
    @State private var onboardingDismissed: Bool = false

    var body: some Scene {
        WindowGroup {
            if !onboardingDismissed && !settings.hasCompletedOnboarding {
                OnboardingView(settings: settings) {
                    onboardingDismissed = true
                }
            } else {
                NavigationStack {
                    ContentView(settings: settings)
                }
            }
        }
    }
}
