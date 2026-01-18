//
//  WordTokenizer.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import Foundation
import NaturalLanguage

struct WordTokenizer {
    static func tokenize(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text

        var tokens: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let token = String(text[range])
            if !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                tokens.append(token)
            }
            return true
        }

        return tokens
    }
}
