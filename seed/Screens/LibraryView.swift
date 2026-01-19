//
//  LibraryView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedText.createdAt, order: .reverse) var texts: [SavedText]
    @State private var searchText = ""

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
                EmptyLibraryView()
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
                            // Navigation to reading session - defer to 06-02
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
        .searchable(text: $searchText, prompt: "Search library...")
        .navigationTitle("Library")
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
        LibraryView()
            .modelContainer(for: SavedText.self, inMemory: true)
    }
}
