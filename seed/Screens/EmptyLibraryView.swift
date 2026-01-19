//
//  EmptyLibraryView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI

struct EmptyLibraryView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "book.closed")
                    .font(.system(size: 64))
                    .foregroundColor(.secondary)

                Text("No texts yet")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Start reading by choosing an input method")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 24)

            VStack(spacing: 16) {
                Button {
                    print("Paste Text selected")
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "doc.text")
                            .font(.title3)
                        Text("Paste Text")
                            .font(.headline)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Button {
                    print("From Link selected")
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "link")
                            .font(.title3)
                        Text("From Link")
                            .font(.headline)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(12)
                }

                Button {
                    print("Upload PDF selected")
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "doc.richtext")
                            .font(.title3)
                        Text("Upload PDF")
                            .font(.headline)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    EmptyLibraryView()
}
