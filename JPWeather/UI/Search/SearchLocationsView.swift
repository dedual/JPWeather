//
//  SearchLocationsView.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/3/23.
//

import Foundation
import SwiftUI

struct SearchLocationsView:View {
    @SwiftUI.Environment(\.isSearching) var isSearching
    @SwiftUI.Environment(\.dismissSearch) var dismissSearch
    // needed because I have an enum called Environment
    
    @State private var previousLocations = [LocationInfo]() // move these to VM (ran out of time to implement)
    @State private var searchLocationsText = ""
    @Binding var selectedTabIndex:Int
    
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
                if filteredRetrievedLocations.count == 0
                {
                    Button {
                        // trigger location request
                        dismissSearch()
                        UserPreferences.tempUseUserLocation = true
                        searchLocationsText = ""
                        selectedTabIndex = 0
                    } label: {
                        Text("Get your local weather report")
                    }
                }
                else
                {
                    ForEach(filteredRetrievedLocations) { location in
                        VStack(alignment: .leading) {
                            Button(action: {
                                // trigger API call
                                dismissSearch()
                                UserPreferences.lastRetrievedLocationInfo = location
                                searchLocationsText = ""
                                selectedTabIndex = 0
                                
                                
                            }){
                                Text(location.name)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Locations")
        }
        .searchable(text: $searchLocationsText)
        .onChange(of: searchLocationsText){ _ in
            runSearch()
        }
        .onSubmit(of: .search, runSearch)
    }
    
    func runSearch(){
        Task {
            if searchLocationsText.count > 2
            {
                let locations = try await APIManager.shared.getTempLocationsInfoFromQuery(address:searchLocationsText)
                await MainActor.run
                {
                    retrievedLocations = locations
                }
            }
            else
            {
                await MainActor.run
                {
                    retrievedLocations = []
                }
            }
        }
    }
}
#Preview {
    SearchLocationsView(selectedTabIndex: .constant(1), retrievedLocations: [])
}
