//
//  ChatMessage.swift
//  ChatBot
//
//  Created by Hye Ri Kim on 7/22/25.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let role: Role
    
    enum Role {
        case user, chatbot
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id && lhs.content == rhs.content && lhs.role == rhs.role
    }
}
