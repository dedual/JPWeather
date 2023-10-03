//
//  NetworkingConstants.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import Foundation

struct NetworkingConstants
{
    struct OpenWeather
    {
        static let host = Environment.openWeatherBaseURL
        static let base = "base/"
        static let version = "2.5/"
        
        // different api paths we currently support
        static let currentWeather = "weather"
        static let forecast = "forecast"
        
        static let staleness_timelapse_seconds:Double = 600.0 // 10 minutes, though for free accounts the documentation states that data can be stale for up to 3 hours (https://openweathermap.org/full-price#current)
    }
}

public enum HTTPMethod:String
{
    case GET
    case POST
    case PUT
    case DELETE
}

extension Encodable {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}

extension Dictionary where Key == String, Value == String {
    func urlEncode() -> Data? {
        do {
            var queryItems: [URLQueryItem] = []
            for (key, value) in self {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            var components = URLComponents()
            components.queryItems = queryItems
            return components.query?.data(using: .utf8)
        }
    }
}

public enum NetworkError: Error, Equatable {
    case badURL(_ error: String)
    case apiError(code: Int, error: String)
    case invalidJSON(_ error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError(code: Int, error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(code: Int, error: String)
}
