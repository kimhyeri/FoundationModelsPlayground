//
//  StoryService.swift
//  CozyTales
//
//  Created by Hye Ri Kim on 1/1/26.
//

import Foundation
import FoundationModels
internal import Combine

@MainActor
final class StoryService: ObservableObject {
    @Published var isAvailable: Bool = false
    @Published var statusMessage: String = ""
    
    private let session: LanguageModelSession
    
    init() {
        // 모델 사용 가능 여부 체크
        let model = SystemLanguageModel.default
        switch model.availability {
        case .available:
            isAvailable = true
            statusMessage = "모델 사용 가능"
        case .unavailable(let reason):
            isAvailable = false
            statusMessage = "모델 사용 불가: \(String(describing: reason))"
        }
        
        self.session = LanguageModelSession {
            """
            You write calming, safe bedtime-style stories for young children.
            Rules:
            - No scary, violent, or threatening content.
            - No medical or drug advice.
            - Use short, simple sentences.
            - Keep a warm, reassuring tone.
            - End with a gentle, calming closing.
            """
        }
    }
    
    func generateStory(
        situation: String,
        minutes: Int,
        likes: String
    ) async throws -> String {
        let target = targetWordCount(forMinutes: minutes)
        let prompt = """
        Situation: \(situation)
        Child likes: \(likes)
        Length: about \(target) words.
        
        Write the story in 4-6 short paragraphs.
        """
        
        let response = try await session.respond(to: prompt)
        return response.content
    }
    
    private func targetWordCount(forMinutes minutes: Int) -> String {
        switch minutes {
        case 1: return "120-180"
        case 3: return "350-500"
        case 5: return "650-900"
        case 8: return "1000-1300"
        case 12: return "1500-1900"
        default: return "350-500"
        }
    }
}
