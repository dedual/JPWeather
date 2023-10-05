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
            ForecastView()
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
    }
}

#Preview {
    ContentView()
}
