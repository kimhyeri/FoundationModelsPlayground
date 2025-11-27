//
//  WorkoutAI.swift
//  WorkoutGuide
//
//  Created by Hye Ri Kim on 11/27/25.
//

import Foundation
import FoundationModels

struct WorkoutAI {
    private let session: LanguageModelSession
    
    init() {
        let instructions = """
        You are a friendly and safe fitness coach.
        Generate short, safe home workout routines in English.
        Avoid medical advice. Keep it simple and beginner-friendly.
        Output should be plain text with bullet points.
        """
        
        self.session = LanguageModelSession(instructions: instructions)
    }
    
    func generatePlan(
        goal: String,
        minutes: Int,
        equipment: String,
        level: String
    ) async throws -> String {
        let prompt = """
        User information:
        - Goal: \(goal)
        - Workout duration: \(minutes) minutes
        - Experience level: \(level)
        - Available equipment: \(equipment)
        
        Please create a full-body workout routine in English that matches the information above.
        
        Format:
        - A short one-line summary at the top
        - Then bullet-point exercises (e.g., • Squats – 3 sets × 12 reps)
        - A short safety or caution note as the last line
        
        Keep it concise, around 8–12 lines in total.
        """
        
        let response = try await session.respond(to: prompt)
        return response.content
    }
}
