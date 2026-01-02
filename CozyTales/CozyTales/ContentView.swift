//
//  ContentView.swift
//  CozyTales
//
//  Created by Hye Ri Kim on 1/1/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var storyService = StoryService()
    @StateObject private var speech = SpeechService()
    
    @State private var situation: String = "On an airplane"
    @State private var likes: String = "bunnies, stars"
    @State private var minutes: Int = 3
    
    @State private var storyText: String = ""
    @State private var isGenerating = false
    @State private var errorText: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Story Settings") {
                    TextField("Situation", text: $situation)
                    TextField("Likes", text: $likes)
                    
                    Picker("Length", selection: $minutes) {
                        Text("1 min").tag(1)
                        Text("3 min").tag(3)
                        Text("5 min").tag(5)
                        Text("8 min").tag(8)
                        Text("12 min").tag(12)
                    }
                }
                
                Section {
                    Button {
                        Task { await generateAndSpeak() }
                    } label: {
                        HStack {
                            Spacer()
                            if isGenerating { ProgressView() }
                            Text(isGenerating ? "Generating..." : "Generate & Play")
                            Spacer()
                        }
                    }
                    .disabled(isGenerating || !storyService.isAvailable)
                    
                    Button("Stop") {
                        speech.stop()
                    }
                }
                
                if let errorText {
                    Section("Error") { Text(errorText) }
                }
                
                Section("Story") {
                    Text(storyText.isEmpty ? "No story yet." : storyText)
                        .textSelection(.enabled)
                }
            }
            .navigationTitle("StoryBook")
        }
    }
    
    @MainActor
    private func generateAndSpeak() async {
        isGenerating = true
        errorText = nil
        storyText = ""
        
        do {
            let story = try await storyService.generateStory(
                situation: situation,
                minutes: minutes,
                likes: likes
            )
            storyText = story
            speech.speak(story)
        } catch {
            errorText = String(describing: error)
        }
        
        isGenerating = false
    }
}
