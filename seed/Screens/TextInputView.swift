//
//  TextInputView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 18/01/26.
//

import SwiftUI

struct TextInputView: View {
    @Binding var text: String
    let onLoad: (String) -> Void

    @State private var showClipboardEmptyAlert = false
    @State private var showValidationAlert = false
    @State private var validationErrorMessage = ""

    private let maxLength = 50_000

    var body: some View {
        VStack(spacing: 20) {
            Text("RSVP Reader")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextEditor(text: $text)
                .frame(minHeight: 200)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .overlay(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Paste or type text here...")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }
                }

            Text("\(text.count) / \(maxLength)")
                .font(.caption)
                .foregroundColor(text.count > maxLength ? .red : .secondary)

            Button {
                pasteFromClipboard()
            } label: {
                Label("Paste from Clipboard", systemImage: "doc.on.clipboard")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Paste text from clipboard")

            Button {
                loadText()
            } label: {
                Text("Load")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(text.isEmpty)
            .accessibilityLabel("Load text for reading")
        }
        .padding()
        .alert("Clipboard Empty", isPresented: $showClipboardEmptyAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("No text found in clipboard")
        }
        .alert("Validation Error", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(validationErrorMessage)
        }
    }

    private func pasteFromClipboard() {
        if let clipboardText = UIPasteboard.general.string, !clipboardText.isEmpty {
            text = clipboardText
        } else {
            showClipboardEmptyAlert = true
        }
    }

    private func loadText() {
        let result = TextValidator.validate(text)
        switch result {
        case .success(let validatedText):
            onLoad(validatedText)
        case .failure(let error):
            validationErrorMessage = error.localizedDescription
            showValidationAlert = true
        }
    }
}

#Preview {
    TextInputView(text: .constant("")) { _ in }
}
