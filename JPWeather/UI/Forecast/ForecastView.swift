//
//  ForecastView.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import SwiftUI

struct ForecastWeatherIconView:View
{
    @State var url:URL?
    @State var description:String
    @State var temperature:String
    @State var feelsLike: String
    @State var visibility:String
    @State var sunrise:String
    @State var sunset:String
            
    var body: some View
    {
        return HStack(alignment:.center, spacing:10.0){
            Spacer()
            VStack(alignment: .center, content: {
                AsyncImage(url:url){ image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        
                } placeholder: {
                    Color.gray
                }.frame(width: 75, height: 75)
                Text(description)
            })
            Spacer()
            VStack(alignment:.leading, spacing: 5)
            {
                Text("\(temperature)").fontWeight(.bold)
                Text("feels like \(feelsLike)")
                Text("Visibility: \(visibility)")
                Text("Sunrise at: \(sunrise)")
                Text("Sunset at: \(sunset)")

            }
            Spacer()
        }
    }
}

struct ForecastView:View {
    
    var currentForecast:Binding<CurrentForecast>
    
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
    
    var body: some View {
        NavigationStack {
            if let weather = currentForecast.forecast.weather.first
            {
                ScrollView{
                    VStack(alignment: .center ,spacing: 10) {
                        ForecastWeatherIconView(url: weather.iconURL,
                                                description: weather.description, 
                                                temperature: "\(cleanNumberDisplay(currentForecast.forecast.coreMeasurements.temperature) + " " +  UserPreferences.getPreferredMeasurementUnit.unitText)",feelsLike:"\(cleanNumberDisplay(currentForecast.forecast.coreMeasurements.feelsLike) + " " +  UserPreferences.getPreferredMeasurementUnit.unitText)",
                                                visibility: "\(cleanNumberDisplay(100.0*currentForecast.forecast.visibilityPercentage))%",
                                                sunrise:makeHourText(date: currentForecast.locationInfo.sunriseDate),
                                                sunset:makeHourText(date: currentForecast.locationInfo.sunsetDate))
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("\(currentForecast.locationInfo.name)").font(.headline)
                        }
                    }
                }
            }
            else
            {
                Text("Pull to refresh current forecast")
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
}
#Preview {
    ForecastView(currentForecast: .constant(CurrentForecast.mock))
}
