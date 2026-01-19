//
//  SavedText.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import Foundation
import SwiftData

@Model
final class SavedText {
    var id: UUID
    var content: String
    var title: String
    var wordCount: Int
    var sourceType: SourceType
    var createdAt: Date
    var lastReadAt: Date?

    enum SourceType: String, Codable {
        case text
        case pdf
        case link
    }

    var previewText: String {
        String(content.prefix(100))
    }

    init(id: UUID = UUID(), content: String, title: String? = nil, sourceType: SourceType, createdAt: Date = Date(), lastReadAt: Date? = nil) {
        self.id = id
        self.content = content
        self.title = title ?? String(content.prefix(50))
        self.wordCount = content.split(separator: " ").count
        self.sourceType = sourceType
        self.createdAt = createdAt
        self.lastReadAt = lastReadAt
    }
}
