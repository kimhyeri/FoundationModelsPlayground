//
//  ContentView.swift
//  WorkoutGuide
//
//  Created by Hye Ri Kim on 11/27/25.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var planText: String = "No workout plan yet.\nTap 'Generate Plan' to begin!"
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    @State private var goal: String = "Fat loss"
    @State private var minutes: Int = 30
    @State private var equipment: String = "Bodyweight"
    @State private var level: String = "Beginner"
    
    private let workoutAI = WorkoutAI()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                inputSection
                
                ScrollView {
                    Text(planText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
                
                Button {
                    Task { await generatePlan() }
                } label: {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Generate Plan")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .font(.headline)
                .background(isLoading ? Color.gray : Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .disabled(isLoading)
            }
            .padding()
            .navigationTitle("AI Workout")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func generatePlan() async {
        errorMessage = nil
        isLoading = true
        
        do {
            let text = try await workoutAI.generatePlan(
                goal: goal,
                minutes: minutes,
                equipment: equipment,
                level: level
            )
            await MainActor.run {
                self.planText = text
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Error generating plan: \(error.localizedDescription)"
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout Preferences")
                .font(.headline)
            
            VStack(alignment: .leading) {
                Text("Goal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Goal", selection: $goal) {
                    Text("Fat loss").tag("Fat loss")
                    Text("Muscle gain").tag("Muscle gain")
                    Text("Maintenance").tag("Maintenance")
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading) {
                Text("Workout Duration (minutes)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Minutes", selection: $minutes) {
                    Text("10").tag(10)
                    Text("20").tag(20)
                    Text("30").tag(30)
                    Text("45").tag(45)
                    Text("60").tag(60)
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading) {
                Text("Equipment")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Equipment", selection: $equipment) {
                    Text("Bodyweight").tag("Bodyweight")
                    Text("Dumbbells").tag("Dumbbells")
                    Text("Gym equipment").tag("Gym equipment")
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading) {
                Text("Experience Level")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Level", selection: $level) {
                    Text("Beginner").tag("Beginner")
                    Text("Intermediate").tag("Intermediate")
                    Text("Advanced").tag("Advanced")
                }
                .pickerStyle(.segmented)
            }
        }
    }
}
