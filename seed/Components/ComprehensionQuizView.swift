//
//  ComprehensionQuizView.swift
//  seed
//
//  Created by Adithya Firmansyah Putra on 19/01/26.
//

import SwiftUI

struct ComprehensionQuizView: View {
    let onDismiss: () -> Void

    @State private var currentQuestionIndex = 0
    @State private var selectedOptionIndex: Int?
    @State private var showFeedback = false
    @State private var score = 0
    @State private var quizCompleted = false

    private let questions = QuizQuestion.sampleQuestions

    private var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }

    private var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                if quizCompleted {
                    completionView
                } else {
                    questionView
                }
            }
            .padding()
            .navigationTitle("Comprehension Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Skip Quiz") {
                        onDismiss()
                    }
                }
            }
        }
    }

    private var questionView: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Score: \(score)/\(currentQuestionIndex)")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.95, green: 0.65, blue: 0.4))
                }

                Text(currentQuestion.text)
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            VStack(spacing: 16) {
                ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                    optionButton(index: index, text: option)
                }
            }

            if showFeedback {
                feedbackView
            }

            Spacer()

            if showFeedback {
                Button(action: nextQuestion) {
                    Text(isLastQuestion ? "Finish" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.95, green: 0.65, blue: 0.4))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
    }

    private func optionButton(index: Int, text: String) -> some View {
        Button(action: {
            if !showFeedback {
                selectOption(index)
            }
        }) {
            HStack {
                Text(text)
                    .foregroundColor(.primary)
                Spacer()
                if showFeedback {
                    if index == currentQuestion.correctIndex {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if index == selectedOptionIndex {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(buttonBackground(for: index))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(buttonBorder(for: index), lineWidth: 2)
                    )
            )
        }
        .disabled(showFeedback)
    }

    private func buttonBackground(for index: Int) -> Color {
        if !showFeedback {
            return Color(UIColor.secondarySystemBackground)
        }
        if index == currentQuestion.correctIndex {
            return Color.green.opacity(0.1)
        }
        if index == selectedOptionIndex {
            return Color.red.opacity(0.1)
        }
        return Color(UIColor.secondarySystemBackground)
    }

    private func buttonBorder(for index: Int) -> Color {
        if !showFeedback {
            return .clear
        }
        if index == currentQuestion.correctIndex {
            return .green
        }
        if index == selectedOptionIndex {
            return .red
        }
        return .clear
    }

    private var feedbackView: some View {
        HStack(spacing: 12) {
            Image(systemName: selectedOptionIndex == currentQuestion.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title)
                .foregroundColor(selectedOptionIndex == currentQuestion.correctIndex ? .green : .red)
            Text(selectedOptionIndex == currentQuestion.correctIndex ? "Correct!" : "Incorrect")
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(selectedOptionIndex == currentQuestion.correctIndex ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        )
    }

    private var completionView: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 0.95, green: 0.65, blue: 0.4))

            Text("Quiz Complete!")
                .font(.title)
                .fontWeight(.bold)

            Text("Your Score")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("\(score)/\(questions.count)")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(Color(red: 0.95, green: 0.65, blue: 0.4))

            Text(scoreMessage)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: onDismiss) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.95, green: 0.65, blue: 0.4))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }

    private var scoreMessage: String {
        let percentage = Double(score) / Double(questions.count)
        if percentage == 1.0 {
            return "Perfect! You've mastered RSVP reading."
        } else if percentage >= 0.67 {
            return "Great job! Keep practicing."
        } else {
            return "Keep reading to improve comprehension."
        }
    }

    private func selectOption(_ index: Int) {
        selectedOptionIndex = index
        showFeedback = true

        if index == currentQuestion.correctIndex {
            score += 1
        }
    }

    private func nextQuestion() {
        if isLastQuestion {
            quizCompleted = true
        } else {
            currentQuestionIndex += 1
            selectedOptionIndex = nil
            showFeedback = false
        }
    }
}

#Preview {
    ComprehensionQuizView {
        print("Quiz dismissed")
    }
}
