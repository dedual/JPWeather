//
//  ForecastView.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import CachedAsyncImage
import SwiftUI

struct ForecastWeatherIconView:View
{
    let currentForecast:CurrentForecast
    
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
            
    var body: some View
    {
        HStack(alignment:.center, spacing:10.0){
            Spacer()
            VStack(alignment: .center, content: {
                CachedAsyncImage(url:currentForecast.forecast.weather.first?.iconURL){ image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        
                } placeholder: {
                    Color.gray
                }.frame(width: 75, height: 75)
                Text(currentForecast.forecast.weather.first?.description ?? "")
            })
            Spacer()
            VStack(alignment:.leading, spacing: 5)
            {
                Text("\(cleanNumberDisplay(currentForecast.forecast.coreMeasurements.temperature))" + " " + "\(UserPreferences.getPreferredMeasurementUnit.unitText)").fontWeight(.bold)
                Text("feels like " + "\(cleanNumberDisplay(currentForecast.forecast.coreMeasurements.temperature))" + " " + "\(UserPreferences.getPreferredMeasurementUnit.unitText)")
                Text("Visibility: \(cleanNumberDisplay(100.0 * currentForecast.forecast.visibilityPercentage))%")
                Text("Sunrise at: \(makeHourText(date: currentForecast.locationInfo.sunriseDate))")
                Text("Sunset at: \(makeHourText(date: currentForecast.locationInfo.sunsetDate))")
            }
            Spacer()
        }
    }
}

struct ForecastView:View {
    
    @StateObject private var viewModel:ForecastViewModel
    
    // MARK: - init
    
    init()
    {
        let localVM = ForecastViewModel()
        _viewModel = StateObject(wrappedValue: localVM)
    }
    
    var body: some View {
        NavigationStack {
            if let forecast = viewModel.currentForecast
            {
                ScrollView{
                    VStack(alignment: .center ,spacing: 10) {
                        ForecastWeatherIconView(currentForecast:forecast)
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("\(forecast.locationInfo.name)").font(.headline)
                        }
                    }
                }
            }
            else
            {
                Text("Cannot retrieve weather forecast").font(.largeTitle)
                Spacer()
                if UserPreferences.lastRetrievedLocationInfo == nil
                {
                    Button {
                        // go to search view
                    } label: {
                        Text("Search for a location in the search view").font(.title)
                    }
                    Text("or maybe").font(.title)
                    Button {
                        // trigger location request
                        viewModel.refreshForecastUsingLocation()
                    } label: {
                        Text("Use your device's location?").font(.title)
                    }
                }
                else
                {
                    Text("Pull to refresh").font(.title)

                }
                    Spacer().toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("Unknown location").font(.headline)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Uh-oh"), message: Text(viewModel.showAlertMessage ?? "An error has occured!"), dismissButton: .default(Text("Okay")))
        }
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .onAppear {
            if UserPreferences.alwaysUseUserLocation
            {
                viewModel.refreshForecastUsingLocation()
            }
            else if let location = UserPreferences.lastRetrievedLocationInfo
            {
                viewModel.refreshForecast(locationInfo:location)
            }
        }.refreshable {
            if UserPreferences.alwaysUseUserLocation
            {
                viewModel.refreshForecastUsingLocation()
            }
            else if let location = UserPreferences.lastRetrievedLocationInfo
            {
                viewModel.refreshForecast(locationInfo: location)
            }
        }
    }
}
#Preview {
    ForecastView()
}
