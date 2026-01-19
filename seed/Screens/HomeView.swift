//
//  HomeView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)

            Text("seed")
                .font(.system(size: 36, weight: .bold))

            Text("Speed read with RSVP")
                .font(.title3)
                .foregroundColor(.secondary)

            Spacer()
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
