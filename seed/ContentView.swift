//
//  ContentView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \SavedText.createdAt, order: .reverse) var savedTexts: [SavedText]
    @State private var selectedTab = 1
    var settings: AppSettings

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            Group {
                if savedTexts.isEmpty {
                    EmptyLibraryView()
                } else {
                    LibraryView()
                }
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical")
            }
            .tag(1)

            LibraryView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(2)
        }
        .preferredColorScheme(settings.colorScheme)
        .onAppear {
            selectedTab = savedTexts.isEmpty ? 0 : 1
        }
    }
}

#Preview {
    ContentView(settings: AppSettings())
        .modelContainer(for: SavedText.self, inMemory: true)
}
