//
//  HistoryView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI

struct HistoryView: View {
    var sessionStore: SessionStore

    private var recentSessions: [ReadingSession] {
        sessionStore.sessions.sorted { $0.endTime > $1.endTime }.prefix(20).map { $0 }
    }

    private var trendSessions: [ReadingSession] {
        Array(recentSessions.prefix(10).reversed())
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if recentSessions.isEmpty {
                        emptyState
                    } else {
                        wpmTrendSection
                        sessionListSection
                    }
                }
                .padding()
            }
            .navigationTitle("History")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No reading sessions yet")
                .font(.title3)
                .foregroundColor(.secondary)
            Text("Complete a reading session to see your history")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }

    private var wpmTrendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(Color(red: 0.95, green: 0.65, blue: 0.4))
                Text("WPM Trend")
                    .font(.headline)
            }

            if trendSessions.count >= 2 {
                WPMLineChart(sessions: trendSessions)
                    .frame(height: 150)
            } else {
                Text("Complete more sessions to see trend")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var sessionListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(.headline)

            ForEach(recentSessions) { session in
                SessionRow(session: session)
            }
        }
    }
}

struct SessionRow: View {
    let session: ReadingSession

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dateFormatter.string(from: session.endTime))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(session.wpm) WPM")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.95, green: 0.65, blue: 0.4))
            }

            HStack(spacing: 16) {
                Label("\(session.wordCount) words", systemImage: "doc.text")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Label(formatDuration(session.duration), systemImage: "clock.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct WPMLineChart: View {
    let sessions: [ReadingSession]

    private var maxWPM: Int {
        sessions.map { $0.wpm }.max() ?? 100
    }

    private var minWPM: Int {
        sessions.map { $0.wpm }.min() ?? 0
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let stepX = width / CGFloat(max(sessions.count - 1, 1))
            let range = CGFloat(max(maxWPM - minWPM, 10))

            ZStack(alignment: .bottomLeading) {
                Path { path in
                    for (index, session) in sessions.enumerated() {
                        let x = CGFloat(index) * stepX
                        let normalizedWPM = CGFloat(session.wpm - minWPM)
                        let y = height - (normalizedWPM / range * height)

                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color(red: 0.95, green: 0.65, blue: 0.4), lineWidth: 2)

                ForEach(Array(sessions.enumerated()), id: \.element.id) { index, session in
                    let x = CGFloat(index) * stepX
                    let normalizedWPM = CGFloat(session.wpm - minWPM)
                    let y = height - (normalizedWPM / range * height)

                    Circle()
                        .fill(Color(red: 0.95, green: 0.65, blue: 0.4))
                        .frame(width: 6, height: 6)
                        .position(x: x, y: y)
                }

                VStack {
                    HStack {
                        Spacer()
                        Text("\(maxWPM) WPM")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(minWPM) WPM")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryView(sessionStore: SessionStore())
}
