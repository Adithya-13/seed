//
//  SessionSetupSheet.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct SessionSetupSheet: View {
    enum InputMode {
        case text, link, pdf
    }

    let inputMode: InputMode
    @Binding var isPresented: Bool

    @State private var textInput = ""
    @State private var urlInput = ""
    @State private var showDocumentPicker = false
    @State private var selectedPDFURL: URL?
    @State private var wpm: Int = 250

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                switch inputMode {
                case .text:
                    textInputView
                case .link:
                    linkInputView
                case .pdf:
                    pdfInputView
                }

                Spacer()

                wpmSelectorView
            }
            .padding()
            .navigationTitle("Start Session from \(modeTitle)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
            }
        }
    }

    private var modeTitle: String {
        switch inputMode {
        case .text: return "Text"
        case .link: return "Link"
        case .pdf: return "PDF"
        }
    }

    private var textInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Paste your text")
                .font(.headline)
            TextEditor(text: $textInput)
                .frame(height: 300)
                .padding(8)
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(8)
        }
    }

    private var linkInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter URL")
                .font(.headline)
            TextField("https://example.com/article", text: $urlInput)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.URL)
                .autocapitalization(.none)
            Text("We'll extract the article text for you")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var pdfInputView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upload PDF")
                .font(.headline)

            Button {
                showDocumentPicker = true
            } label: {
                HStack {
                    Image(systemName: "doc.richtext")
                    Text(selectedPDFURL?.lastPathComponent ?? "Choose PDF File")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)

            if selectedPDFURL != nil {
                Text("PDF selected - extraction in next phase")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(selectedURL: $selectedPDFURL)
        }
    }

    private var wpmSelectorView: some View {
        VStack(spacing: 16) {
            Text("Reading Speed")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach([150, 250, 350, 450, 550], id: \.self) { speed in
                        Button {
                            wpm = speed
                        } label: {
                            Text("\(speed)")
                                .font(.headline)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(wpm == speed ? Color.accentColor : Color(uiColor: .systemGray5))
                                .foregroundColor(wpm == speed ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }

            HStack(spacing: 24) {
                Button {
                    wpm = max(50, wpm - 25)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }

                VStack(spacing: 4) {
                    Text("\(wpm)")
                        .font(.system(size: 48, weight: .bold))
                    Text("words per minute")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Button {
                    wpm = min(1000, wpm + 25)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .padding(.vertical)
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedURL = urls.first
        }
    }
}
