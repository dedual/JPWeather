//
//  MultiDayForecastResponse.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import Foundation

struct MultiDayForecast:Codable, Equatable
{
    let forecasts:[Forecast]
    let locationInfo:LocationInfo
    
    enum CodingKeys:String, CodingKey
    {
        case forecasts = "list"
        case location = "city"
    }
    
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)

        self.forecasts = try container.decode([Forecast].self, forKey: .forecasts)
        self.locationInfo = try container.decode(LocationInfo.self, forKey: .location)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(forecasts, forKey: .forecasts)
        try container.encode(locationInfo, forKey: .location)
    }
}
