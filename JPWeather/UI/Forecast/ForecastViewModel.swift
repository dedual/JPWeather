//
//  ForecastViewModel.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import Combine

class ForecastViewModel: ObservableObject {
    @Published private (set) var currentForecast:CurrentForecast?
    @Published private (set) var multidayForecast:MultiDayForecast?
    @Published private (set) var isLoading:Bool = false
    @Published var showAlert:Bool = false
    
    @Published private (set) var showAlertMessage:String?
    // quick way to show alerts and errors. We'll want to link to device settings in case
    // location permissions are rejected and the user is trying to use them.
    
    // MARK: - Methods
    func cleanNumberDisplay(_ input:Double) -> String
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
    
    func makeHourText(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: date)
    }
    // MARK: - API Calls
    
    private func refreshForecast(lat:Double, lon:Double) async
    {
        isLoading = true
        Task{
            do
            {
                let tempWeather = try await APIManager.shared.current(latitude: lat, longitude: lon)
                let tempMultiForecast = try await APIManager.shared.forecast(latitude: lat, longitude: lon)
                
                await MainActor.run {
                    self.currentForecast = tempWeather
                    self.multidayForecast = tempMultiForecast
                    UserPreferences.lastRetrievedLocationInfo = tempWeather.locationInfo
                    UserPreferences.lastUpdated = .now
                    showAlert = false
                    isLoading = false
                }
            }
            catch let error as RequestError
            {
                await MainActor.run {
                    showAlertMessage = error.customMessage
                    showAlert = true
                    isLoading = false
                }
            }
            catch
            {
                await MainActor.run {
                    showAlertMessage = error.localizedDescription
                    showAlert = true
                    isLoading = false
                }
            }
        }
    }
    
    func refreshForecast(locationInfo:LocationInfo) async
    {
        await self.refreshForecast(lat: locationInfo.owLat, lon: locationInfo.owLon)
    }
    
    func refreshForecastUsingLocation() async
    {
        isLoading = true

        do{
            let location = try await APIManager.shared.getCurrentLocation()
            await self.refreshForecast(lat: location.latitude, lon: location.longitude)
        }
        catch let error as LocationError
        {
            showAlertMessage = error.customMessage
            showAlert = true
            isLoading = false
        }
        catch
        {
            showAlertMessage = error.localizedDescription
            showAlert = true
            isLoading = false
        }
    }
}
