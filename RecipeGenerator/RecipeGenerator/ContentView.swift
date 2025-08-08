//
//  ContentView.swift
//  RecipeGenerator
//
//  Created by Hye Ri Kim on 8/8/25.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var session = LanguageModelSession()
    @State private var recipe: Recipe.PartiallyGenerated?
    @State private var userInput: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    TextField("What would you like to cook?", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                    
                    Button("Generate") {
                        UIApplication.shared.endEditing()
                        Task {
                            await generateRecipe()
                        }
                    }
                    .disabled(userInput.isEmpty)
                }
                
                ScrollView {
                    if let recipe {
                        VStack(alignment: .leading) {
                            if let title = recipe.title {
                                Text(title)
                                    .font(.title)
                                    .bold()
                            }
                            
                            if let ingredients = recipe.ingredients {
                                Text("Ingredients:")
                                    .font(.headline)
                                ForEach(ingredients, id: \.self) { item in
                                    Text("- \(item)")
                                }
                            }
                            
                            if let steps = recipe.steps {
                                Text("Instructions:")
                                    .font(.headline)
                                Text(steps)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    } else if isLoading {
                        VStack {
                            Spacer()
                            ProgressView("Generating recipe")
                                .padding()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .padding()
            .navigationTitle("AI Recipe Generator")
        }
    }

    func generateRecipe() async {
        isLoading = true
        recipe = nil
        do {
            let stream = session.streamResponse(generating: Recipe.self) {
                "Give me a recipe for \(userInput)"
            }
            for try await partial in stream {
                self.recipe = partial
            }
        } catch {
            print("Recipe generation error: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
}
