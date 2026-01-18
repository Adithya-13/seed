//
//  TextValidator.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import Foundation

struct TextValidator {
    enum ValidationError: Error, LocalizedError {
        case empty
        case tooShort
        case tooLong

        var errorDescription: String? {
            switch self {
            case .empty:
                return "Text is empty"
            case .tooShort:
                return "Text must be at least 10 characters"
            case .tooLong:
                return "Text exceeds maximum length of 50,000 characters"
            }
        }
    }

    static func validate(_ text: String) -> Result<String, ValidationError> {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .failure(.empty)
        }

        if trimmed.count < 10 {
            return .failure(.tooShort)
        }

        if trimmed.count > 50_000 {
            return .failure(.tooLong)
        }

        let normalized = trimmed
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return .success(normalized)
    }
}
