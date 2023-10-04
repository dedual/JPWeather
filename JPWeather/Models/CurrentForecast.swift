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
}
