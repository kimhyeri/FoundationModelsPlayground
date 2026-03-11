//
//  ContentView.swift
//  WeatherOutfitAdvisor
//
//  Created by Hye Ri Kim on 3/9/26.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var viewModel = WeatherOutfitViewModel()
    @State private var cityInput: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Header
                    VStack(spacing: 6) {
                        Text("🌤️ Weather Outfit Advisor")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Enter a city and get AI-powered outfit suggestions")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 8)

                    // MARK: - Input
                    HStack(spacing: 10) {
                        TextField("City name (e.g. Seoul, Tokyo)", text: $cityInput)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                            .onSubmit { viewModel.fetchOutfitAdvice(for: cityInput) }

                        Button {
                            viewModel.fetchOutfitAdvice(for: cityInput)
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundStyle(cityInput.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                        }
                        .disabled(cityInput.trimmingCharacters(in: .whitespaces).isEmpty || viewModel.isLoading)
                    }
                    .padding(.horizontal)

                    // MARK: - Weather Card
                    if let weather = viewModel.weather {
                        WeatherCardView(weather: weather)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // MARK: - Outfit Advice
                    if !viewModel.adviceText.isEmpty {
                        OutfitAdviceView(text: viewModel.adviceText, isStreaming: viewModel.isStreaming)
                            .transition(.opacity)
                    }

                    // MARK: - Loading
                    if viewModel.isLoading && viewModel.weather == nil {
                        ProgressView("Checking weather...")
                            .padding()
                    }

                    // MARK: - Error
                    if let error = viewModel.errorMessage {
                        Label(error, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .padding()
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .animation(.easeInOut(duration: 0.3), value: viewModel.weather != nil)
            .animation(.easeInOut(duration: 0.3), value: viewModel.adviceText)
        }
    }
}

// MARK: - Weather Card

struct WeatherCardView: View {
    let weather: WeatherData

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(weather.city)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(weather.condition)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(weather.weatherEmoji)
                    .font(.system(size: 48))
            }

            Divider()

            HStack(spacing: 0) {
                WeatherStatView(label: "Temp", value: "\(weather.temperatureCelsius)°C")
                Divider().frame(height: 36)
                WeatherStatView(label: "Humidity", value: "\(weather.humidityPercent)%")
                Divider().frame(height: 36)
                WeatherStatView(label: "Wind", value: "\(weather.windSpeedKmh) km/h")
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct WeatherStatView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Outfit Advice Card

struct OutfitAdviceView: View {
    let text: String
    let isStreaming: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Outfit Suggestion", systemImage: "tshirt.fill")
                    .font(.headline)
                Spacer()
                if isStreaming {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}
