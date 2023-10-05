//
//  ForecastViewModel.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import Combine

class ForecastViewModel:ObservableObject {
    @Published private (set) var currentForecast:CurrentForecast?
    @Published private (set) var multidayForecast:MultiDayForecast?
    @Published private (set) var isLoading:Bool = false
    @Published var showAlert:Bool = false
    @Published private (set) var showAlertMessage:String?
    // quick way to show alerts and errors. We'll want to link to device settings in case
    // location permissions are rejected and the user is trying to use them.
    
    // MARK: - Methods
    
    func refreshForecast(locationInfo:LocationInfo)
    {
        isLoading = true
        Task{
            do{
                let tempWeather = try await APIManager.shared.current(latitude: locationInfo.owLat, longitude: locationInfo.owLon)
                let multiForecast = try await APIManager.shared.forecast(latitude: locationInfo.owLat, longitude: locationInfo.owLon)

                // doing both at the same time as we don't need to parallelize the returns.
                // they return quick enough
                
                await MainActor.run {
                    self.currentForecast = tempWeather
                    self.multidayForecast = multiForecast

                    UserPreferences.lastRetrievedLocationInfo = tempWeather.locationInfo
                    UserPreferences.lastUpdated = .now
                    showAlert = false
                    showAlertMessage = nil
                    isLoading = false
                }
            }
            catch let error as RequestError
            {
                showAlertMessage = error.customMessage
                showAlert = true
                print(error)
                isLoading = false
            }
        }
    }
    
    func refreshForecastUsingLocation()
    {
        // function is slow AF because the core location calls are being done on the main thread. Ridiculous, must rethink this
        isLoading = true
        Task{
            do{
                let tempWeather = try await APIManager.shared.currentUsingCoreLocation()
                let multiForecast = try await APIManager.shared.forecastUsingCoreLocation()

                // doing both at the same time as we don't need to parallelize the returns.
                // they return quick enough
                
                await MainActor.run {
                    self.currentForecast = tempWeather
                    self.multidayForecast = multiForecast

                    UserPreferences.lastRetrievedLocationInfo = tempWeather.locationInfo
                    UserPreferences.lastUpdated = .now
                    showAlert = false
                    showAlertMessage = nil
                    isLoading = false
                }
            }
            catch let error as RequestError
            {
                showAlertMessage = error.customMessage
                showAlert = true
                isLoading = false
            }
            
            catch let error as LocationError
            {
                showAlertMessage = error.customMessage
                showAlert = true
                isLoading = false
            }
        }
    }
}
