//
//  TestData.swift
//  JPWeatherTests
//
//  Created by Nicolas Dedual on 10/24/23.
//

import Foundation
import CoreLocation

enum TestData
{
    case paris
    case newyork
    case harlem
    case veniceUncertain
    case invalidLocation

    var location:CLLocationCoordinate2D
    {
        switch self {
        case .paris:
            return CLLocationCoordinate2D(latitude: 48.858677079685634, longitude: 2.2944851172211354)
        case .newyork:
            return CLLocationCoordinate2D(latitude: 40.760618131634374, longitude: -73.98003200771446)
        case .harlem:
            return CLLocationCoordinate2D(latitude: 40.809964731782834, longitude: -73.95010733420638)
        case .invalidLocation:
            return CLLocationCoordinate2D(latitude: -120.0, longitude: 270)
        case .veniceUncertain:
            return CLLocationCoordinate2D()
        }
    }
    
    var locationAddress:String
    {
        switch self {
        case .paris:
            return "Champ de Mars, 5 Av. Anatole France, 75007 Paris, France"
        case .newyork:
            return "1260 6th Ave, New York, NY 10020"
        case .harlem:
            return "253 W 125th St, New York, NY 10027"
        case .invalidLocation:
            return "Gobbledygook!"
        case .veniceUncertain:
            return "Venice"
        }
    }
}
