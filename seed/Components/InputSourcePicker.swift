//
//  InputSourcePicker.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI

enum InputSource: String, CaseIterable {
    case paste = "Paste"
    case url = "URL"
    case pdf = "PDF"

    var icon: String {
        switch self {
        case .paste: return "doc.text"
        case .url: return "link"
        case .pdf: return "doc.fill"
        }
    }
}

struct InputSourcePicker: View {
    @State private var selectedSource: InputSource = .paste
    @State private var urlInput: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showDocumentPicker: Bool = false
    @State private var inputText: String = ""

    let urlExtractor = URLArticleExtractor()
    let pdfExtractor = PDFTextExtractor()

    let onTextReady: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Picker("Input Source", selection: $selectedSource) {
                ForEach(InputSource.allCases, id: \.self) { source in
                    Label(source.rawValue, systemImage: source.icon)
                        .tag(source)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Group {
                switch selectedSource {
                case .paste:
                    TextInputView(text: $inputText) { text in
                        onTextReady(text)
                    }
                case .url:
                    urlInputView
                case .pdf:
                    pdfInputView
                }
            }

            if isLoading {
                ProgressView("Loading...")
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPickerView(contentTypes: PDFTextExtractor.supportedTypes) { url in
                Task {
                    await extractPDF(from: url)
                }
            }
        }
    }

    private var urlInputView: some View {
        VStack(spacing: 12) {
            TextField("Enter article URL", text: $urlInput)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .padding(.horizontal)

            Button("Extract Article") {
                Task {
                    await extractURL()
                }
            }
            .disabled(urlInput.isEmpty || isLoading)
            .buttonStyle(.borderedProminent)
        }
    }

    private var pdfInputView: some View {
        VStack(spacing: 12) {
            Text("Select a PDF file to extract text")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button("Choose PDF File") {
                showDocumentPicker = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
    }

    private func extractURL() async {
        isLoading = true
        errorMessage = nil

        do {
            let text = try await urlExtractor.extract(from: urlInput)
            validateAndLoad(text)
        } catch {
            errorMessage = "Failed to extract article: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func extractPDF(from url: URL) async {
        isLoading = true
        errorMessage = nil

        do {
            let text = try await pdfExtractor.extractText(from: url)
            validateAndLoad(text)
        } catch {
            errorMessage = "Failed to extract PDF: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func validateAndLoad(_ text: String) {
        switch TextValidator.validate(text) {
        case .success(let validText):
            onTextReady(validText)
        case .failure(let error):
            errorMessage = "Validation failed: \(error.localizedDescription)"
        }
    }
}
