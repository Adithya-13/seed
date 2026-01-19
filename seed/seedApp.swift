//
//  seedApp.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI
import SwiftData

@main
struct seedApp: App {
    @State private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(settings: settings)
            }
        }
        .modelContainer(for: SavedText.self)
    }
}
