//
//  Weather.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import Foundation

struct Weather: Codable, Equatable
{
    let idWeather:String
    let main:String
    let description:String
    let iconString:String 
    
    enum CodingKeys:String, CodingKey
    {
        case idWeather = "id"
        case mainWeather = "main"
        case descriptionWeather = "description"
        case iconString = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.idWeather = try container.decode(String.self, forKey: .idWeather)
        self.main = try container.decode(String.self, forKey: .mainWeather)
        self.description = try container.decode(String.self, forKey: .descriptionWeather)
        self.iconString = try container.decode(String.self, forKey: .iconString)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(idWeather, forKey: .idWeather)
        try container.encode(main, forKey: .mainWeather)
        try container.encode(description, forKey: .descriptionWeather)
        try container.encode(iconString, forKey: .iconString)

    }
}
