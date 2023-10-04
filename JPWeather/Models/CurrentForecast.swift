//
//  SingleDayForecast.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import SwiftUI

struct CurrentForecast:Codable, Equatable
{
    let forecast:Forecast
    let locationInfo:LocationInfo
    
    init(from decoder: Decoder) throws {
        
        let forecastContainer = try decoder.singleValueContainer()
        self.forecast = try forecastContainer.decode(Forecast.self)
        self.locationInfo = try forecastContainer.decode(LocationInfo.self)
    }
    
    static var mock:CurrentForecast
    {
        if let url = Bundle.main.url(forResource: "TestCurrentForecast", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(CurrentForecast.self, from: data)
                    return jsonData
                } catch {
                    print("error:\(error)")
                    fatalError("Error: \(error)")
                }
            }
        else {
            fatalError("Could not open test json file")
        }
    }
}
