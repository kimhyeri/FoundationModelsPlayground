//
//  ChatView.swift
//  ChatBot
//
//  Created by Hye Ri Kim on 7/22/25.
//

import SwiftUI
import FoundationModels
import Combine

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var lastMessageID: UUID?

    var body: some View {
        VStack {
            chatMessagesView
            Divider()
            inputView
        }
        .onTapGesture {
            isInputFocused = false
        }
    }

    private var chatMessagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages) { msg in
                        MessageBubble(message: msg)
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .onChange(of: viewModel.messages) { oldMessages, newMessages in
                if let lastID = newMessages.last?.id {
                    lastMessageID = lastID
                    withAnimation {
                        proxy.scrollTo(lastID, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var inputView: some View {
        HStack {
            TextField("Enter your message", text: $viewModel.currentInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isInputFocused)
                .submitLabel(.send)
                .onSubmit {
                    sendMessage()
                }

            Button(action: sendMessage) {
                Text("Send")
            }
            .disabled(viewModel.isLoading || viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }

    private func sendMessage() {
        Task {
            isInputFocused = true
            await viewModel.send()
            if let lastID = viewModel.messages.last?.id {
                lastMessageID = lastID
            }
        }
    }
}
