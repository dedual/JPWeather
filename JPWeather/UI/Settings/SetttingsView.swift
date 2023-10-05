//
//  SetttingsView.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import SwiftUI

struct SettingsView: View
{
    @State private var selectedUnit: TemperatureUnit = UserPreferences.getPreferredMeasurementUnit
    
    @State private var alwaysUseLocation:Bool = UserPreferences.alwaysUseUserLocation
    @Binding var selectedTabIndex:Int

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("User Preferences"),
                footer: Text("Here we can define some typical user preferences we use within the application"))
                {
                    Picker("Preferred temperature units", selection: $selectedUnit) {
                        ForEach(TemperatureUnit.all, id: \.self) { aTemperatureUnit in
                            Text(aTemperatureUnit.label).tag(aTemperatureUnit)
                                }
                    }.onChange(of: selectedUnit) { _ in
                        UserPreferences.setPreferredMeasurementUnit(value: selectedUnit.rawValue)
                    }
                    Toggle(isOn: $alwaysUseLocation) {
                        Text("Always use device location on app load")
                    }.onChange(of: alwaysUseLocation){_ in
                    
                        UserPreferences.alwaysUseUserLocation = alwaysUseLocation
                        // we should prevent setting this
                        // boolean if the user hasn't given us
                        // location permissions
                        
                    }
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}
#Preview {
    SettingsView(selectedTabIndex: .constant(2))
}
