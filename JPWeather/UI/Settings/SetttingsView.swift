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
                    
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}
#Preview {
    SettingsView()
}
