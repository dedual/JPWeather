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
            ForecastView(selectedTabIndex: $selectedTabIndex)
                .tag(0)
                .tabItem {
                    Label("Current", systemImage: "network")
                }
            SearchLocationsView(selectedTabIndex: $selectedTabIndex)
                .tag(1)
                .tabItem {
                    Label("Locations", systemImage: "magnifyingglass")
                }
            SettingsView(selectedTabIndex: $selectedTabIndex)
                .tag(2)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            VideoView(selectedTabIndex: $selectedTabIndex)
                .tag(3)
                .tabItem{
                    Label("UIKit View", systemImage: "shippingbox.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
