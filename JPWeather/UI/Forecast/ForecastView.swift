//
//  ForecastView.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import SwiftUI

struct ForecastView:View {
    var body: some View {
        NavigationStack {
            Text("To display current weather here")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("<location>").font(.headline)
                    }
                }
            }
        }
    }
}
#Preview {
    ForecastView()
}
