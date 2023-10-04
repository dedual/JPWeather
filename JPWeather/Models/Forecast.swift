//
//  Forecast.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import Foundation

struct Forecast:Codable, Equatable
{
    let coreMeasurements:CoreMeasurements
    let weather:[Weather]
    
   // let base: String
    let visibilityInMeters:Int
    let visibilityPercentage:Double
    
    let windSpeed:Double
    let windDirection:Int // meterological degrees
    let windGust:Double?
    
    let cloudiness:Int // reported as percentage (but backend has it as an Int?. Weird)
    
    var rain1H:Double? // not necessarily available
    var rain3H:Double? // not necessarily available
    
    var snow1H:Double? // not necessarily available
    var snow3H:Double? // not necessarily available
        
    let dt_timestamp:Int // also used for forecast time
    
    var probPrecipitation:Double? // used in multi-day forecast
    
    // computed values
    var lastUpdatedDate:Date
    {
        return Date(timeIntervalSince1970: TimeInterval(dt_timestamp))
    }
    
    enum ContainerKeys:String, CodingKey
    {
        case weather = "weather"
        case main
        case wind
        case clouds
        case rain
        case snow
        //case base
        case visibility
        case probPrecipitation = "pop"
        case dt
        case forecastID = "id"
        case timezone // not used right now
        case name
    }
    
    enum CodingKeys:String, CodingKey
    {
        case speed
        case deg
        case gust
        case all
        case pod
        case oneH = "1h"
        case threeH = "3h"
    }
    
    init(from decoder: Decoder) throws 
    {
        let values = try decoder.container(keyedBy: ContainerKeys.self)
        let wind = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .wind)
        let clouds = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .clouds)
        let rain = try? values.nestedContainer(keyedBy: CodingKeys.self, forKey: .rain)
        let snow = try? values.nestedContainer(keyedBy: CodingKeys.self, forKey: .snow)
        
        self.weather = try values.decode([Weather].self, forKey: .weather)
        self.coreMeasurements = try values.decode(CoreMeasurements.self, forKey: .main)
        
        //self.base = try values.decode(String.self, forKey: .base)
        
        self.visibilityInMeters = try values.decode(Int.self, forKey: .visibility)
        self.visibilityPercentage = Double(self.visibilityInMeters) / 10000.0
        
        self.probPrecipitation = try? values.decode(Double.self, forKey: .probPrecipitation)
       
        self.windSpeed = try wind.decode(Double.self, forKey: .speed)
        self.windGust = try? wind.decode(Double.self, forKey: .gust)
        self.windDirection = try wind.decode(Int.self, forKey: .deg)
        
        self.cloudiness = try clouds.decode(Int.self, forKey: .all)
        
        self.rain1H = try? rain?.decode(Double.self, forKey: .oneH)
        self.rain3H = try? rain?.decode(Double.self, forKey: .threeH)
        
        self.snow1H = try? snow?.decode(Double.self, forKey: .oneH)
        self.snow3H = try? snow?.decode(Double.self, forKey: .threeH)
        
        self.dt_timestamp = try values.decode(Int.self, forKey: .dt)
    }
    
    func encode(to encoder: Encoder) throws {
        // TODO: to finish tomorrow
        var container = encoder.container(keyedBy: ContainerKeys.self)
        var wind = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .wind)
        var clouds = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .clouds)
        var rain = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .rain)
        var snow = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snow)
        
        try container.encode(weather, forKey: .weather)
        try container.encode(coreMeasurements, forKey: .main)

       // try container.encode(base, forKey: .base)
        try container.encode(visibilityInMeters, forKey: .visibility)
        
        try wind.encode(windSpeed, forKey: .speed)
        try? wind.encode(windGust, forKey: .gust)
        try wind.encode(windDirection, forKey: .deg)

        try clouds.encode(cloudiness, forKey: .all)
        
        try? rain.encode(rain1H, forKey: .oneH)
        try? rain.encode(rain3H, forKey: .threeH)

        try? snow.encode(snow1H, forKey: .oneH)
        try? snow.encode(snow3H, forKey: .threeH)

        try container.encode(dt_timestamp, forKey: .dt)
    }
}
