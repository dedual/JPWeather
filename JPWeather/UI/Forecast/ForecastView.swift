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
                        if let multidayForecast = viewModel.multidayForecast
                        {
                            Text("Forecast").font(.title)
                            HStack(alignment: .center){
                                for aForecast in multidayForecast
                                {
                                    Button {
                                        // this would have linked to
                                        // a detail forecast
                                    } label: {
                                        VStack(alignment: .center, content: {
                                            Text("\(viewModel.makeHourText($0.dt))")
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
