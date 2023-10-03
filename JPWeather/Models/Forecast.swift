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
    
    let owLat:Double // want to distinguish this data from CoreLocation-derived latitude and longitudes
    let owLon:Double
    
    let base:String
    let visibilityInMeters:Int
    let visibilityPercentage:Double
    
    let windSpeed:Double
    let windDirection:Int // meterological degrees
    let windGust:Double
    
    let cloudiness:Int // reported as percentage (but backend has it as an Int?. Weird)
    
    var rain1H:Double? // not necessarily available
    var rain3H:Double? // not necessarily available
    
    var snow1H:Double? // not necessarily available
    var snow3H:Double? // not necessarily available
    
    let countryCode:String
    
    let dt_timestamp:Int
    let sunrise_timestamp:Int
    let sunset_timestamp:Int
    let name:String

    var forecasted_timestamp:Int? // used in multi-day forecast
    var forecasted_timeOfDay:String? // used in multi-day forecast
    
    var probPrecipitation:Double? // used in multi-day forecast
    
    // computed values
    var lastUpdatedDate:Date
    {
        return Date(timeIntervalSince1970: TimeInterval(dt_timestamp))
    }
    
    var sunriseDate:Date
    {
        return Date(timeIntervalSince1970: TimeInterval(sunrise_timestamp))
    }
    
    var sunsetDate:Date
    {
        return Date(timeIntervalSince1970: TimeInterval(sunset_timestamp))
    }
    
    enum ContainerKeys:String, CodingKey
    {
        case coord
        case weather
        case main
        case wind
        case clouds
        case rain
        case snow
        case sys
        case base
        case visibility
        case dt
        case forecaseID = "id"
        case timezone // not used right now
        case name
    }
    
    enum CodingKeys:String, CodingKey
    {
        case lon
        case lat
        case speed
        case deg
        case gust
        case all
        case sysType = "type"
        case sysID = "id"
        case country
        case sunrise
        case sunset
        case oneH = "1h"
        case threeH = "3h"
    }
    
    init(from decoder: Decoder) throws 
    {
        let values = try decoder.container(keyedBy: ContainerKeys.self)
        let coord = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .coord)
        let wind = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .wind)
        let clouds = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .clouds)
        let rain = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .rain)
        let snow = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .snow)

        let sys = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .sys)
        
        self.weather = try values.decode([Weather].self, forKey: .weather)
        self.coreMeasurements = try values.decode(CoreMeasurements.self, forKey: .main)
        self.owLat = try coord.decode(Double.self, forKey: .lat)
        self.owLon = try coord.decode(Double.self, forKey: .lon)
        
        self.base = try values.decode(String.self, forKey: .base)
        
        self.visibilityInMeters = try values.decode(Int.self, forKey: .visibility)
        self.visibilityPercentage = Double(self.visibilityInMeters) / 10000.0
       
        self.windSpeed = try wind.decode(Double.self, forKey: .speed)
        self.windGust = try wind.decode(Double.self, forKey: .gust)
        self.windDirection = try wind.decode(Int.self, forKey: .deg)
        
        self.cloudiness = try clouds.decode(Int.self, forKey: .all)
        
        self.rain1H = try rain.decode(Double.self, forKey: .oneH)
        self.rain3H = try rain.decode(Double.self, forKey: .threeH)
        
        self.snow1H = try snow.decode(Double.self, forKey: .oneH)
        self.snow3H = try snow.decode(Double.self, forKey: .threeH)
        
        self.dt_timestamp = try values.decode(Int.self, forKey: .dt)
        
    }
    
}
