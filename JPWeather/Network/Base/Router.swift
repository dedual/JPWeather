//
//  Router.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import Foundation

enum Router:Equatable
{
    case current(lat:Double, lon:Double)
    case forecast(lat:Double, lon:Double)
    case currentWithQuery(query:String)
    case forecastWithQuery(query:String)
    // note: don't use OpenWeather's geocoding service. Apple provides a more accurate one that's free to iOS developers
    
    var url:String
    {
        switch self
        {
        case .current, .currentWithQuery:
            return NetworkingConstants.OpenWeather.host +
            NetworkingConstants.OpenWeather.base +
            NetworkingConstants.OpenWeather.version +
            NetworkingConstants.OpenWeather.currentWeather

            
        case .forecast, .forecastWithQuery:
            return NetworkingConstants.OpenWeather.host +
            NetworkingConstants.OpenWeather.base +
            NetworkingConstants.OpenWeather.version +
            NetworkingConstants.OpenWeather.forecast
        }
    }
    
    var headers:[String:String]?
    {
        switch self
        {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body:Data?
    {
        switch self
        {
        default:
            return nil
        }
    }
    
    var queryItems:[URLQueryItem]?
    {
        switch self
        {
        case .current(let lat, let lon):
            return [
                URLQueryItem(name:"lat", value: "\(lat)"),
                URLQueryItem(name:"lon", value: "\(lon)"),
                URLQueryItem(name:"appid", value: Environment.openWeatherAPIKey),
                URLQueryItem(name:"units", value: UserPreferences.getPreferredMeasurementUnit),
                URLQueryItem(name:"lang", value: UserPreferences.getPreferredLanguage),
            ]
        case .currentWithQuery(let query):
            return [
                URLQueryItem(name:"q", value: "\(query)"),
                URLQueryItem(name:"appid", value: Environment.openWeatherAPIKey),
                URLQueryItem(name:"units", value: UserPreferences.getPreferredMeasurementUnit),
                URLQueryItem(name:"lang", value: UserPreferences.getPreferredLanguage),
            ]
        case .forecast(let lat, let lon):
            return [
                URLQueryItem(name:"lat", value: "\(lat)"),
                URLQueryItem(name:"lon", value: "\(lon)"),
                URLQueryItem(name:"appid", value: Environment.openWeatherAPIKey),
                URLQueryItem(name:"units", value: UserPreferences.getPreferredMeasurementUnit),
                URLQueryItem(name:"lang", value: UserPreferences.getPreferredLanguage),
            ]
        case .forecastWithQuery(let query):
            return [
                URLQueryItem(name:"q", value: "\(query)"),
                URLQueryItem(name:"appid", value: Environment.openWeatherAPIKey),
                URLQueryItem(name:"units", value: UserPreferences.getPreferredMeasurementUnit),
                URLQueryItem(name:"lang", value: UserPreferences.getPreferredLanguage),
            ]

        }
    }
    
    var httpMethod:HTTPMethod
    {
        switch self
        {
        default:
            return .GET
        }
    }
    
    func buildURLRequest() -> URLRequest? {
        
        var urlComponents = URLComponents(string: url)
        if let parameters = queryItems, parameters.count > 0
        {
            urlComponents?.queryItems = parameters
        }
        
        guard let finalURL = urlComponents?.url else { return nil}
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? [:]
        urlRequest.httpBody = body

        return urlRequest
    }
}
