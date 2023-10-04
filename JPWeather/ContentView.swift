//
//  ContentView.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTabIndex = 0
    @State var currentForecast:CurrentForecast = .mock
    
    var body: some View {
        
        TabView(selection: $selectedTabIndex) {
            ForecastView(currentForecast: $currentForecast)
                .tag(0)
                .tabItem {
                    Label("Current", systemImage: "network")
                }
            SearchLocationsView()
                .tag(1)
                .tabItem {
                    Label("Locations", systemImage: "magnifyingglass")
                }
            SettingsView()
                .tag(2)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .onAppear{
            Task {
                do{
                    let tempWeather = try await APIManager.shared.current(latitude: 40.83009389151496, longitude: -73.94816973208368)
                    self.currentForecast = tempWeather

                    await MainActor.run {
                        self.currentForecast = tempWeather
                        print(tempWeather)

                    }
                }
                catch
                {
                    print(error)
                }
            }
             Task{
                do{
                    let multiForecast = try await APIManager.shared.forecast(latitude: 40.83009389151496, longitude: -73.94816973208368)
                    
                    await MainActor.run {
                        print(multiForecast)
                    }
                } catch 
                {
                    print(error)
                }
            } 
        }
    }
}

#Preview {
    ContentView()
}
