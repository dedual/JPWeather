//
//  APIManager.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import Foundation
import Combine
import CoreLocation // we need it for CLGeocoder
import MapKit // to get better searching for locations

protocol APIManagerProtocol
{
    func current(latitude:Double, longitude:Double) async throws -> CurrentForecast
    func current(address:String) async throws -> CurrentForecast
    func forecast(latitude:Double, longitude:Double) async throws -> MultiDayForecast
    func forecast(address:String) async throws -> MultiDayForecast
}

public class APIManager: HTTPClient, APIManagerProtocol
{
    static var requestTimeOut:Float = 15.0
    static var refreshInterval = TimeInterval(NetworkingConstants.OpenWeather.staleness_timelapse_seconds)
    static let shared = APIManager() // it's not as much in fashion to use singletons
    
    private let geocoder = CLGeocoder()
    private let localRequest = MKLocalSearch.Request()
    
    // MARK: - To be used later when implementing caching
    private var lastUpdated: Date {
       get {
          UserDefaults.standard.object(forKey: UserPreferences.Keys.lastUpdated) as! Date
       }
       set {
          UserDefaults.standard.set(newValue, forKey: UserPreferences.Keys.lastUpdated)
       }
    }
    
    private var shouldUpdate: Bool {
        if abs(lastUpdated.timeIntervalSinceNow) > APIManager.refreshInterval {
          return true
       }
       return false
    }

    // MARK: - Private functions
    
    func getTempLocationInfoObjects(address:String) async throws -> [LocationInfo]?
    {
        localRequest.naturalLanguageQuery = address
        var localSearch = MKLocalSearch(request:localRequest)
        
        let searchResponse = try await localSearch.start()
        
        let tempLocationInfos = searchResponse.mapItems.compactMap { aMapItem in
            return LocationInfo(name: aMapItem.name ?? aMapItem.placemark.title ?? aMapItem.placemark.locality ?? address,
                                latitude: aMapItem.placemark.coordinate.latitude,
                                longitude: aMapItem.placemark.coordinate.longitude)
        }
            
        if tempLocationInfos.count == 0
        {
            return nil
        }
        
        return tempLocationInfos
    }
    
    private func getGeocoderValue(address:String) async throws -> CLLocationCoordinate2D?
    {
        let placemarks = try await geocoder.geocodeAddressString(address)
        
        let validLocations = placemarks.compactMap { aPlacemark in
            if let location = aPlacemark.location
            {
                return location.coordinate
            }
            else
            {
                return nil
            }
        }
        
        if validLocations.count == 0
        {
            // Something went wrong, let's try with OpenWeather's query
            return nil
        }
        
        return validLocations.first! // why first? Apple only returns one value via CLGeocoder
    }
    // MARK: - API calls -
    func current(latitude: Double, longitude: Double) async throws -> CurrentForecast {
        return try await sendRequest(endpoint: .current(lat: latitude, lon: longitude), responseModel: CurrentForecast.self)
    }
    
    func current(address: String) async throws -> CurrentForecast {
        
        // get Lat/Lon from Apple's Geocoder

        let location = try await getGeocoderValue(address: address)
        
        if let currentLocation = location
        {
            return try await sendRequest(endpoint: .current(lat: currentLocation.latitude, lon: currentLocation.longitude), responseModel: CurrentForecast.self)
        }
        
        // why do this?
        // 1) Seems OpenWeatherAPI better supports GPS-derived results rather than queries, and we don't want to query the API again
        // as that costs money
        // 2) There was a notice that the query-based results were going to be deprecated? Out of an overabundance of caution, we'll default to Apple results first
        
        return try await sendRequest(endpoint: .currentWithQuery(query: address), responseModel: CurrentForecast.self)
       
    }
    
    func forecast(latitude: Double, longitude: Double) async throws -> MultiDayForecast {
        return try await sendRequest(endpoint: .forecast(lat: latitude, lon: longitude), responseModel: MultiDayForecast.self)
    }
    
    func forecast(address: String) async throws -> MultiDayForecast{
        let location = try await getGeocoderValue(address: address)
        
        if let currentLocation = location
        {
            return try await sendRequest(endpoint: .forecast(lat: currentLocation.latitude, lon: currentLocation.longitude), responseModel: MultiDayForecast.self)
        }
        
        return try await sendRequest(endpoint: .forecastWithQuery(query: address), responseModel: MultiDayForecast.self)
    }
    
}
