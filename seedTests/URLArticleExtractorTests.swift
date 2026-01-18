//
//  URLArticleExtractorTests.swift
//  seedTests
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import XCTest
@testable import seed

final class URLArticleExtractorTests: XCTestCase {
    func testInvalidURL() async {
        let extractor = URLArticleExtractor()
        do {
            _ = try await extractor.extract(from: "not-a-url")
            XCTFail("Should throw invalidURL error")
        } catch URLExtractionError.invalidURL {
            // Expected
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    func testEmptyStringURL() async {
        let extractor = URLArticleExtractor()
        do {
            _ = try await extractor.extract(from: "")
            XCTFail("Should throw invalidURL error")
        } catch URLExtractionError.invalidURL {
            // Expected
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    func testHTMLStripping() async throws {
        let extractor = URLArticleExtractor()

        // Test with example.com which returns simple HTML
        let text = try await extractor.extract(from: "https://example.com")
        XCTAssertFalse(text.isEmpty, "Extracted text should not be empty")
        XCTAssertFalse(text.contains("<"), "HTML tags should be stripped")
        XCTAssertFalse(text.contains(">"), "HTML tags should be stripped")
    }
}
