//
//  JPWeatherApp.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import SwiftUI

@main
struct JPWeatherApp: App {
    @StateObject private var playerState = PlayerState()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(playerState)
        }
    }
}
