//
//  ForecastView.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import CachedAsyncImage
import SwiftUI

struct ForecastView:View {
    @Binding var selectedTabIndex:Int

    @StateObject private var viewModel:ForecastViewModel
    
    // MARK: - init
    
    init(selectedTabIndex:Binding<Int>)
    {
        self._selectedTabIndex = selectedTabIndex
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
                        VStack(alignment: .center ,spacing: 10) {
                            HStack(alignment: .center, spacing: 10.0)
                            {
                                Spacer()
                                Text("Lows at: " + "\(viewModel.cleanNumberDisplay(forecast.forecast.coreMeasurements.minTemperature))" + " " + "\(UserPreferences.getPreferredMeasurementUnit.unitText)")
                                    .font(.headline)
                                Spacer()
                                Text("Highs at: " + "\(viewModel.cleanNumberDisplay(forecast.forecast.coreMeasurements.maxTemperature))" + " " + "\(UserPreferences.getPreferredMeasurementUnit.unitText)").font(.headline)
                                Spacer()
                            }
                        }
                        Spacer()
                        VStack(alignment: .center ,spacing: 10) {
                            HStack(alignment: .center, spacing: 10.0)
                            {
                                Spacer()
                                Text("Pressure at: " + "\(forecast.forecast.coreMeasurements.pressure)" + " " + "hPa")
                                    .font(.headline)
                                Spacer()
                                Text("Humidity at: " + "\(forecast.forecast.coreMeasurements.humidity)" + " " + "%").font(.headline)
                                Spacer()
                            }
                        }
                        Spacer()
                        if let multidayForecast = viewModel.multidayForecast
                        {
                            Text("Forecast").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading)
                            ScrollView(.horizontal)
                            {
                                HStack(alignment: .center, spacing: 10.0)
                                {
                                    ForEach(multidayForecast.forecasts){ aForecast in
                                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                            VStack(alignment:.center) {
                                                Text("\(viewModel.makeHourText(date: aForecast.dateForecasted))").bold()
                                                CachedAsyncImage(url:aForecast.weather.first?.iconURL){ image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        
                                                } placeholder: {
                                                    Color.gray
                                                }.frame(width: 75, height: 75)
                                                Text(aForecast.weather.first?.description ?? "")
                                            }
                                        })
                                    }
                                }
                            }
                        }
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
            if UserPreferences.alwaysUseUserLocation || UserPreferences.tempUseUserLocation
            {
                viewModel.refreshForecastUsingLocation()
                UserPreferences.tempUseUserLocation = false
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
    ForecastView(selectedTabIndex: .constant(0))
}
