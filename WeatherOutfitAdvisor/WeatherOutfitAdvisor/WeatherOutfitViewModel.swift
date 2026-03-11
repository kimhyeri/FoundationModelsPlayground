//
//  WeatherOutfitViewModel.swift
//  WeatherOutfitAdvisor
//
//  Created by Hye Ri Kim on 3/9/26.
//

import Foundation
import FoundationModels
import Observation

@MainActor
@Observable
final class WeatherOutfitViewModel {

    // MARK: - State

    var weather: WeatherData? = nil
    var adviceText: String = ""
    var isLoading: Bool = false
    var isStreaming: Bool = false
    var errorMessage: String? = nil

    // MARK: - Private

    private var currentTask: Task<Void, Never>? = nil

    // MARK: - Entry Point

    func fetchOutfitAdvice(for city: String) {
        let trimmed = city.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        currentTask?.cancel()

        weather = nil
        adviceText = ""
        errorMessage = nil
        isLoading = true

        currentTask = Task {
            await run(for: trimmed)
        }
    }

    // MARK: - Core Logic

    private func run(for city: String) async {
        defer {
            isLoading = false
            isStreaming = false
        }

        do {
            guard case .available = SystemLanguageModel.default.availability else {
                errorMessage = "On-device model is not available on this device."
                return
            }

            // Tool captures WeatherData via callback — no JSON parsing from model response
            let tool = GetWeatherTool()
            tool.onWeatherFetched = { [weak self] data in
                self?.weather = data
                self?.isLoading = false
            }

            let session = LanguageModelSession(
                tools: [tool],
                instructions: """
                You are a weather and fashion assistant.
                When asked about weather, always call the get_weather tool first.
                Then suggest an outfit based on the weather data returned.
                """
            )

            try Task.checkCancellation()

            // Single-turn: model calls tool + streams outfit advice in one response
            isStreaming = true
            let stream = session.streamResponse(
                to: "What's the weather like in \(city) today, and what outfit should I wear?"
            )

            for try await partial in stream {
                try Task.checkCancellation()
                adviceText = partial.content
            }

        } catch is CancellationError {
            // silently clean up
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
