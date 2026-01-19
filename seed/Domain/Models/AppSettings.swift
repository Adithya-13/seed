//
//  AppSettings.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI
import Observation

@Observable
class AppSettings {
    @ObservationIgnored @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @ObservationIgnored @AppStorage("lastUsedWPM") var lastUsedWPM: Int = 250
    @ObservationIgnored @AppStorage("fontSize") var fontSize: Double = 32
    @ObservationIgnored @AppStorage("colorSchemeString") private var colorSchemeString: String = "system"
    @ObservationIgnored @AppStorage("focusMode") var focusMode: Bool = false

    var colorScheme: ColorScheme? {
        get {
            switch colorSchemeString {
            case "light": return .light
            case "dark": return .dark
            default: return nil
            }
        }
        set {
            switch newValue {
            case .light: colorSchemeString = "light"
            case .dark: colorSchemeString = "dark"
            case nil: colorSchemeString = "system"
            }
        }
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}
