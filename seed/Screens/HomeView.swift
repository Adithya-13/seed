//
//  HomeView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedText.createdAt, order: .reverse) var texts: [SavedText]
    @State private var searchText = ""
    @State private var showSessionSheet = false
    @State private var selectedInputMode: SessionSetupSheet.InputMode?

    private var filteredTexts: [SavedText] {
        if searchText.isEmpty {
            return texts
        }
        return texts.filter { text in
            text.title.localizedCaseInsensitiveContains(searchText) ||
            text.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if texts.isEmpty {
                VStack(spacing: 32) {
                    Spacer()

                    VStack(spacing: 24) {
                        Image(systemName: "bolt.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.accentColor)

                        Text("seed")
                            .font(.system(size: 36, weight: .bold))

                        Text("Speed read with RSVP")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }

                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)

                        Text("No texts yet")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Start reading by choosing an input method")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 32)

                    VStack(spacing: 16) {
                        Button {
                            selectedInputMode = .text
                            showSessionSheet = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.text")
                                    .font(.title3)
                                Text("Paste Text")
                                    .font(.headline)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }

                        Button {
                            selectedInputMode = .link
                            showSessionSheet = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "link")
                                    .font(.title3)
                                Text("From Link")
                                    .font(.headline)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundColor(.accentColor)
                            .cornerRadius(12)
                        }

                        Button {
                            selectedInputMode = .pdf
                            showSessionSheet = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.richtext")
                                    .font(.title3)
                                Text("Upload PDF")
                                    .font(.headline)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundColor(.accentColor)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 32)

                    Spacer()
                }
                .padding()
            } else if filteredTexts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No results")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                List {
                    ForEach(filteredTexts) { text in
                        Button {
                            print("Navigate to: \(text.id)")
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: sourceIcon(for: text.sourceType))
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                                    .frame(width: 32)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(text.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Text("\(text.wordCount) words")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    if let lastRead = text.lastReadAt {
                                        Text("Last read: \(lastRead, format: .relative(presentation: .named))")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                Spacer()
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteText(text)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search library...")
        .navigationTitle("Home")
        .sheet(isPresented: $showSessionSheet) {
            if let mode = selectedInputMode {
                SessionSetupSheet(inputMode: mode, isPresented: $showSessionSheet)
            }
        }
    }

    private func sourceIcon(for sourceType: SavedText.SourceType) -> String {
        switch sourceType {
        case .text:
            return "doc.text"
        case .link:
            return "link"
        case .pdf:
            return "doc.richtext"
        }
    }

    private func deleteText(_ text: SavedText) {
        modelContext.delete(text)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
