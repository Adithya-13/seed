//
//  URLArticleExtractor.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import Foundation

enum URLExtractionError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case extractionFailed
    case noContent

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL format"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .extractionFailed:
            return "Failed to extract article content"
        case .noContent:
            return "No text content found"
        }
    }
}

actor URLArticleExtractor {
    func extract(from urlString: String) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw URLExtractionError.invalidURL
        }

        let (data, _): (Data, URLResponse)
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch {
            throw URLExtractionError.networkError(error)
        }

        guard let html = String(data: data, encoding: .utf8) else {
            throw URLExtractionError.noContent
        }

        let cleanText = stripHTML(from: html)

        guard !cleanText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw URLExtractionError.noContent
        }

        return cleanText
    }

    private func stripHTML(from html: String) -> String {
        var text = html

        // Remove scripts and styles
        text = text.replacingOccurrences(
            of: "<script[^>]*>[\\s\\S]*?</script>",
            with: "",
            options: .regularExpression
        )
        text = text.replacingOccurrences(
            of: "<style[^>]*>[\\s\\S]*?</style>",
            with: "",
            options: .regularExpression
        )

        // Remove HTML tags
        text = text.replacingOccurrences(
            of: "<[^>]+>",
            with: " ",
            options: .regularExpression
        )

        // Decode HTML entities
        text = text.replacingOccurrences(of: "&nbsp;", with: " ")
        text = text.replacingOccurrences(of: "&amp;", with: "&")
        text = text.replacingOccurrences(of: "&lt;", with: "<")
        text = text.replacingOccurrences(of: "&gt;", with: ">")
        text = text.replacingOccurrences(of: "&quot;", with: "\"")
        text = text.replacingOccurrences(of: "&#39;", with: "'")

        // Clean up whitespace
        text = text.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )

        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
