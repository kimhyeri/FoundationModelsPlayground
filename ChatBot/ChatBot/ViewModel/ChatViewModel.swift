//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Hye Ri Kim on 7/22/25.
//

import Foundation
import FoundationModels
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentInput: String = ""
    @Published var isLoading: Bool = false
    
    private var session: LanguageModelSession?
    private var conversationHistory: [String] = []
    private let conversationHistoryLimit: Int = 10
    
    init() {
        let instructions = """
        You are a chatbot with a great sense of humor.  
        Engage the user with friendly and lighthearted conversation, occasionally adding humorous remarks.  
        Avoid excessive jokes and keep the conversation flowing naturally.
        Respond in a concise manner, typically with 1-3 sentences.
        """
        self.session = LanguageModelSession(instructions: instructions)
    }

    func send() async {
        guard !currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = currentInput
        currentInput = ""
        
        messages.append(Message(content: userMessage, role: .user))
        isLoading = true
        
        do {
            let response = try await sendToAI(text: userMessage)
            messages.append(Message(content: response, role: .chatbot))
        } catch {
            messages.append(Message(content: "Error: \(error.localizedDescription)", role: .chatbot))
        }
        
        isLoading = false
    }

    private func sendToAI(text: String) async throws -> String {
        guard let session = session else {
            throw NSError()
        }
        
        conversationHistory.append("User: \(text)")
        
        let prompt = """
        Previous conversation:
        \(conversationHistory.joined(separator: "\n"))
        
        Chatbot: Let me respond to the user's latest message in a friendly and slightly humorous way.
        
        Response:
        """
        
        let response = try await session.respond(to: prompt)
        
        conversationHistory.append("Chatbot: \(response.content)")
        
        if conversationHistory.count > conversationHistoryLimit {
            conversationHistory = Array(conversationHistory.suffix(conversationHistoryLimit))
        }
        
        return response.content
    }
}
