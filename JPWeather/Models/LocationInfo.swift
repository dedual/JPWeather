//
//  LocationInfo.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation

struct LocationInfo:Codable, Equatable, Identifiable
{
    let id:Int
    var name:String
    
    let owLat:Double
    let owLon:Double
    let sunrise_timestamp:Int
    let sunset_timestamp:Int
    
    var country:String?
    var population:Int?
    
    // computed values
    var sunriseDate:Date
    {
        return Date(timeIntervalSince1970: TimeInterval(sunrise_timestamp))
    }
    
    var sunsetDate:Date
    {
        return Date(timeIntervalSince1970: TimeInterval(sunset_timestamp))
    }
    
    enum CodingKeys:String, CodingKey
    {
        case name
        case coord
        case sys
        case locationId = "id"
    }
    
    enum CityKeys:String, CodingKey
    {
        case name
        case coord
        case country
        case population
        case sunrise
        case sunset
        case sys
        case cityId = "id"
    }
    
    enum CoordKeys:String, CodingKey
    {
        case lat
        case lon
    }
    
    enum SysKeys:String, CodingKey
    {
        case sunrise
        case sunset
        case country
    }
    
    init(id:Int = Int.random(in:1..<10000), 
         name:String,
         latitude:Double,
         longitude:Double,
         sunrise:Int = 1,
         sunset:Int = 1,
         country:String? = nil,
         population:Int? = nil)
    {
        // constructor used for temporary LocationInfo
        
        self.name = name
        self.id = id
        self.owLat = latitude
        self.owLon = longitude
        self.sunrise_timestamp = sunrise
        self.sunset_timestamp = sunset
        self.population = population
        self.country = country
    }
    
    static var mock:LocationInfo
    {
        return LocationInfo(id: 5110253,
                            name: "Bronx County",
                            latitude: 40.8301,
                            longitude: -73.9482,
                            sunrise: 1696416899,
                            sunset: 1696458838,
                            country: "US", 
                            population: 1385108)
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let sysContainer = try? values.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        {
            // we're in the current forecast (we should do else if let here if we're going to support other inconsistent calls that use
            // data model like the one defined in Forecast)
            // we're doing 'else' so that we guarantee that the non-optional values are filled
            
            // we're in the multi-hour forecast
            let coordContainer = try values.nestedContainer(keyedBy: CoordKeys.self, forKey: .coord)
            
            self.name = try values.decode(String.self, forKey: .name)
            self.id = try values.decode(Int.self, forKey: .locationId)
            self.sunrise_timestamp = try sysContainer.decode(Int.self, forKey: .sunrise)
            self.sunset_timestamp = try sysContainer.decode(Int.self, forKey: .sunset)
            self.country = try? sysContainer.decode(String.self, forKey: .country)
            
            self.owLat = try coordContainer.decode(Double.self, forKey: .lat)
            self.owLon = try coordContainer.decode(Double.self, forKey: .lon)
        }
        else
        {
            // we're in the multi-hour forecast
            let values = try decoder.container(keyedBy: CityKeys.self)

            let coordContainer = try values.nestedContainer(keyedBy: CoordKeys.self, forKey: .coord)

            self.name = try values.decode(String.self, forKey: .name)
            self.id = try values.decode(Int.self, forKey: .cityId)
            self.sunrise_timestamp = try values.decode(Int.self, forKey: .sunrise)
            self.sunset_timestamp = try values.decode(Int.self, forKey: .sunset)
            self.country = try? values.decode(String.self, forKey: .country)
            self.owLat = try coordContainer.decode(Double.self, forKey: .lat)
            self.owLon = try coordContainer.decode(Double.self, forKey: .lon)
            self.population = try? values.decode(Int.self, forKey: .population)
            
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CityKeys.self)
        
        var coordContainer = container.nestedContainer(keyedBy: CoordKeys.self, forKey: .coord)
        
        try container.encode(name, forKey: .name)
        try container.encode(sunrise_timestamp, forKey: .sunrise)
        try container.encode(sunset_timestamp, forKey: .sunset)
        try? container.encode(country, forKey: .country)
        try? container.encode(population, forKey: .population)
        try coordContainer.encode(owLat, forKey: .lat)
        try coordContainer.encode(owLon, forKey: .lon)
        
    }
}
