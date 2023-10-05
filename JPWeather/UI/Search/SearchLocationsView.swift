//
//  SearchLocationsView.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import SwiftUI

struct SearchLocationsView:View {
    @State private var previousLocations = [LocationInfo]() // move these to VM
    @State private var searchLocationsText = ""
    
    @State var retrievedLocations: [LocationInfo] = []

    private var filteredRetrievedLocations: [LocationInfo]
    {
        if searchLocationsText.isEmpty
        {
            return previousLocations
        }
        else
        {
            return retrievedLocations
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredRetrievedLocations) { location in
                    VStack(alignment: .leading) {
                        Button(action: {
                            // trigger API call
                        }){
                            Text(location.name)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Locations")
        }
        .searchable(text: $searchLocationsText)
        .onAppear(perform: runSearch)
        .onChange(of: searchLocationsText){ _ in
            runSearch()
        }
        .onSubmit(of: .search, runSearch)
    }
    
    func runSearch(){
        Task {
            let locations = try await APIManager.shared.getTempLocationInfoObjects(address:searchLocationsText) ?? []
            await MainActor.run
            {
                retrievedLocations = locations
            }
        }
    }
}
#Preview {
    SearchLocationsView(retrievedLocations: [])
}
