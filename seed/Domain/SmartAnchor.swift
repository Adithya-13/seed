//
//  SmartAnchor.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import Foundation

struct SmartAnchor {
    static func anchorRange(for word: String) -> Range<String.Index>? {
        guard !word.isEmpty else { return nil }

        let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
        guard !cleanWord.isEmpty else { return nil }

        let length = cleanWord.count
        let anchorLength: Int

        switch length {
        case 1...3:
            anchorLength = 1
        case 4...8:
            anchorLength = 2
        default:
            anchorLength = 3
        }

        let endIndex = cleanWord.index(cleanWord.startIndex, offsetBy: min(anchorLength, cleanWord.count))
        return cleanWord.startIndex..<endIndex
    }
}
