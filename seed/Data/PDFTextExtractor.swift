//
//  PDFTextExtractor.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import PDFKit
import UniformTypeIdentifiers

enum PDFExtractionError: Error, LocalizedError {
    case fileAccessDenied
    case invalidPDF
    case noTextContent
    case extractionFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileAccessDenied:
            return "Cannot access PDF file"
        case .invalidPDF:
            return "Invalid or corrupted PDF"
        case .noTextContent:
            return "PDF contains no text content"
        case .extractionFailed(let error):
            return "Text extraction failed: \(error.localizedDescription)"
        }
    }
}

actor PDFTextExtractor {
    func extractText(from url: URL) async throws -> String {
        guard let pdfDoc = PDFDocument(url: url) else {
            throw PDFExtractionError.invalidPDF
        }

        var fullText = ""
        for pageIndex in 0..<pdfDoc.pageCount {
            guard let page = pdfDoc.page(at: pageIndex) else { continue }

            if let pageText = page.string {
                fullText += pageText + "\n\n"
            }
        }

        guard !fullText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw PDFExtractionError.noTextContent
        }

        return fullText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static var supportedTypes: [UTType] {
        [.pdf]
    }
}
