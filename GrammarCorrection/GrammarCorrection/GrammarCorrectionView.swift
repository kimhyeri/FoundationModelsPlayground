//
//  GrammarCorrectionView.swift
//  GrammarCorrection
//
//  Created by Hye Ri Kim on 7/24/25.
//

import SwiftUI
import FoundationModels

struct GrammarCorrectionView: View {
    @State private var userInput: String = ""
    @State private var correctionResult: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("📝 Enter a sentence you'd like to correct")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextEditor(text: $userInput)
                .frame(height: 120)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                .padding(.horizontal, 4)

            HStack {
                Button(action: {
                    userInput = ""
                    correctionResult = ""
                    errorMessage = nil
                }) {
                    Label("Clear", systemImage: "xmark.circle")
                }
                .buttonStyle(.bordered)

                Spacer()

                Button(action: {
                    Task {
                        await correctSentence()
                    }
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "wand.and.stars")
                            Text("Correct Grammar")
                        }
                    }
                }
                .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                .buttonStyle(.borderedProminent)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            if !correctionResult.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Correction & Explanation")
                        .font(.headline)
                    ScrollView {
                        Text(correctionResult)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(minHeight: 100)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
    }

    func correctSentence() async {
        isLoading = true
        correctionResult = ""
        errorMessage = nil

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        do {
            let instructions = "You are a helpful and knowledgeable English tutor. When a student provides a sentence, check it for grammar mistakes. If there are any, explain what is wrong and provide the corrected sentence. If the sentence is already correct, confirm that it is correct and explain why."
            let session = LanguageModelSession(instructions: instructions)

            let prompt = """
            Please check the following sentence for any grammar mistakes. If there are mistakes, explain them and provide the corrected version. If the sentence is already correct, explain why it is correct.
            \"\(userInput.trimmingCharacters(in: .whitespacesAndNewlines))\"
            """
            
            let response = try await session.respond(to: prompt)
            correctionResult = response.content
        } catch {
            errorMessage = "Failed to get response: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
