//
//  WeatherData.swift
//  WeatherOutfitAdvisor
//
//  Created by Hye Ri Kim on 3/9/26.
//

import Foundation
import FoundationModels

// MARK: - Weather Data Model

struct WeatherData {
    let city: String
    let temperatureCelsius: Int
    let condition: String
    let humidityPercent: Int
    let windSpeedKmh: Int

    var weatherEmoji: String {
        switch condition.lowercased() {
        case let c where c.contains("sunny") || c.contains("clear"): return "☀️"
        case let c where c.contains("partly cloudy"):                return "⛅️"
        case let c where c.contains("cloudy") || c.contains("overcast"): return "☁️"
        case let c where c.contains("rain") || c.contains("drizzle"): return "🌧️"
        case let c where c.contains("snow"):                         return "🌨️"
        case let c where c.contains("storm") || c.contains("thunder"): return "⛈️"
        case let c where c.contains("fog") || c.contains("mist"):   return "🌫️"
        default:                                                     return "🌤️"
        }
    }
}

// MARK: - GetWeatherTool

/// FoundationModels Tool that fetches weather for a city.
/// The fetched WeatherData is captured via `onWeatherFetched` callback
/// so the ViewModel can update UI without parsing the model's prose response.
final class GetWeatherTool: Tool {

    let name = "get_weather"
    let description = "Returns the current weather conditions for a given city, including temperature, humidity, wind speed, and a short condition description."

    /// Called on MainActor when the model invokes this tool.
    var onWeatherFetched: ((WeatherData) -> Void)?

    @Generable
    struct Arguments {
        @Guide(description: "The name of the city to get weather for, e.g. 'Seoul', 'New York', 'Tokyo'")
        var city: String
    }

    func call(arguments: Arguments) async throws -> GeneratedContent {
        let data = mockWeather(for: arguments.city)

        // Capture WeatherData directly — no JSON parsing needed later
        await MainActor.run {
            onWeatherFetched?(data)
        }

        // Return JSON string so the model can incorporate it into its response
        let json = """
        {
          "city": "\(data.city)",
          "temperature_celsius": \(data.temperatureCelsius),
          "condition": "\(data.condition)",
          "humidity_percent": \(data.humidityPercent),
          "wind_speed_kmh": \(data.windSpeedKmh)
        }
        """
        return GeneratedContent(json)
    }

    // MARK: - Mock Data

    private func mockWeather(for city: String) -> WeatherData {
        switch city.lowercased().trimmingCharacters(in: .whitespaces) {
        case "seoul", "서울":
            return WeatherData(city: "Seoul", temperatureCelsius: 4, condition: "Partly Cloudy", humidityPercent: 60, windSpeedKmh: 14)
        case "tokyo", "도쿄":
            return WeatherData(city: "Tokyo", temperatureCelsius: 11, condition: "Sunny", humidityPercent: 45, windSpeedKmh: 8)
        case "new york", "뉴욕":
            return WeatherData(city: "New York", temperatureCelsius: -1, condition: "Snow", humidityPercent: 78, windSpeedKmh: 22)
        case "london", "런던":
            return WeatherData(city: "London", temperatureCelsius: 8, condition: "Overcast", humidityPercent: 82, windSpeedKmh: 18)
        case "los angeles", "la", "엘에이":
            return WeatherData(city: "Los Angeles", temperatureCelsius: 22, condition: "Sunny", humidityPercent: 35, windSpeedKmh: 10)
        case "sydney", "시드니":
            return WeatherData(city: "Sydney", temperatureCelsius: 28, condition: "Clear", humidityPercent: 55, windSpeedKmh: 12)
        case "paris", "파리":
            return WeatherData(city: "Paris", temperatureCelsius: 6, condition: "Rainy", humidityPercent: 88, windSpeedKmh: 16)
        case "singapore", "싱가포르":
            return WeatherData(city: "Singapore", temperatureCelsius: 32, condition: "Thunderstorm", humidityPercent: 90, windSpeedKmh: 20)
        case "dubai", "두바이":
            return WeatherData(city: "Dubai", temperatureCelsius: 35, condition: "Sunny", humidityPercent: 28, windSpeedKmh: 7)
        default:
            return WeatherData(city: city.capitalized, temperatureCelsius: 18, condition: "Partly Cloudy", humidityPercent: 55, windSpeedKmh: 12)
        }
    }
}
