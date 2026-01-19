//
//  SettingsView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var settings: AppSettings

    var body: some View {
        Form {
            Section("Display") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Font Size: \(Int(settings.fontSize))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Slider(value: $settings.fontSize, in: 16...48, step: 2)
                }

                Picker("Theme", selection: $settings.colorScheme) {
                    Text("System").tag(nil as ColorScheme?)
                    Text("Light").tag(ColorScheme.light as ColorScheme?)
                    Text("Dark").tag(ColorScheme.dark as ColorScheme?)
                }
            }

            Section("Reading") {
                Toggle("Focus Mode", isOn: $settings.focusMode)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(settings: AppSettings())
    }
}
