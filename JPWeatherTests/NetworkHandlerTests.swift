//
//  NetworkHandlerTests.swift
//  JPWeatherTests
//
//  Created by Nicolas Dedual on 10/24/23.
//

import XCTest
@testable import JPWeather

final class NetworkHandlerTests: XCTestCase
{
    var apiManager = APIManager.shared
    
    func testCurrentForecastRequestByLatLon() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given location")
        do {
            let data = try await apiManager.current(latitude: TestData.paris.location.latitude, longitude: TestData.paris.location.longitude)
            print("Data received: \(data)")
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testCurrentForecastRequestErrorBadInputData() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given location, but return error")
        do {
            let data = try await apiManager.current(latitude: TestData.invalidLocation.location.latitude, longitude: TestData.invalidLocation.location.longitude)
            print("Data received: \(data)")
        } catch let error {
            print("⚠️\(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
}
