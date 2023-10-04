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
    
    @Published private (set) var cleanedTemperature:String?
    @Published private (set) var cleanedFeelsLikeTemperature:String?
    
    private var locationInfo:LocationInfo
    
    // MARK: - Functions
    
    init(locationInfo:LocationInfo) {
        self.locationInfo = locationInfo
        refreshForecast(locationInfo: locationInfo)
    }
    
    // MARK: - Methods
    
    func refreshForecast(locationInfo:LocationInfo)
    {
        Task{
            do{
                let tempWeather = try await APIManager.shared.current(latitude: locationInfo.owLat, longitude: locationInfo.owLon)
                // update text variables
                if let temperature = currentForecast?.forecast.coreMeasurements.temperature
                {
                    self.cleanedTemperature = "\(cleanNumberDisplay(temperature) + " " +  UserPreferences.getPreferredMeasurementUnit.unitText)"
                }
                else
                {
                    self.cleanedTemperature = nil
                }
                
                if let feelsLike = currentForecast?.forecast.coreMeasurements.feelsLike
                {
                    self.cleanedFeelsLikeTemperature = "\(cleanNumberDisplay(feelsLike)) \(UserPreferences.getPreferredMeasurementUnit.unitText)"
                }
                else
                {
                    self.cleanedFeelsLikeTemperature = nil
                }

                self.currentForecast = tempWeather
            }
            catch
            {
                print(error)
            }
        }
        Task{
            do
            {
                let multiForecast = try await APIManager.shared.forecast(latitude: locationInfo.owLat, longitude: locationInfo.owLon)
            }
            catch
            {
                print(error)
            }
        }
    }
    
    private func cleanNumberDisplay(_ input:Double) -> String // candidate for viewmodel
    {
        let formatter = NumberFormatter()

        formatter.usesSignificantDigits = true
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = 2
        
        if let result = formatter.string(from: input as NSNumber) {
            return result
        }
        else
        {
            return "\(input)"
        }
    }
    
    private func makeHourText(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: date)
    }
}
