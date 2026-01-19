//
//  QuizQuestion.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
    let correctIndex: Int
}

extension QuizQuestion {
    static let sampleQuestions: [QuizQuestion] = [
        QuizQuestion(
            text: "What does RSVP reading help eliminate?",
            options: ["Eye movement", "Comprehension", "Speed", "Focus"],
            correctIndex: 0
        ),
        QuizQuestion(
            text: "How does anchoring work in RSVP?",
            options: ["Bold first letters", "Color coding", "Size changes", "Position shifts"],
            correctIndex: 0
        ),
        QuizQuestion(
            text: "What improves with RSVP practice?",
            options: ["All of these", "Speed only", "Focus only", "Retention only"],
            correctIndex: 0
        )
    ]
}
