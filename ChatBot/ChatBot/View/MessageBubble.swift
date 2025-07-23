//
//  MessageBubble.swift
//  ChatBot
//
//  Created by Hye Ri Kim on 7/22/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role.isUser {
                Spacer()
            }

            Text(message.content)
                .padding(12)
                .background(message.role.bubbleColor)
                .cornerRadius(12)

            if message.role.isChatBot {
                Spacer()
            }
        }
    }
}

extension Message.Role {
    var bubbleColor: Color {
        switch self {
        case .user:
            return Color.blue.opacity(0.9)
        case .chatbot:
            return Color.gray.opacity(0.15)
        }
    }
    
    var isUser: Bool {
        return self == .user
    }
    
    var isChatBot: Bool {
        return self == .chatbot
    }
}
