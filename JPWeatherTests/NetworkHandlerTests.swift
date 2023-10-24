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
        let expectation = XCTestExpectation(description: "Perform network request with given location, but returns error")
        do {
            let data = try await apiManager.current(latitude: TestData.invalidLocation.location.latitude, longitude: TestData.invalidLocation.location.longitude)
            print("Data received: \(data)")
        } catch let error {
            print("⚠️\(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testCurrentForecastRequestByAddress() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given text address")
        do {
            let data = try await apiManager.current(address: TestData.paris.locationAddress)
            print("Data received: \(data)")
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testCurrentForecastRequestByAddressNoGeocoding() async
    {
        // ensure we're testing OpenAPI's Weather by address query endpoint
        // normally we have this wrapped up and no
        let expectation = XCTestExpectation(description: "Perform network request with given text address, no geocoding via Apple")
        do {
            let data = try await apiManager.sendRequest(endpoint: .currentWithQuery(query: TestData.paris.locationAddress), responseModel:CurrentForecast.self)
            
            print("Data received: \(data)")
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testCurrentForecastRequestByAddressInvalidData() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given text address, but returns error")
        do {
            let data = try await apiManager.current(address: TestData.invalidLocation.locationAddress)
            print("Data received: \(data)")

        } catch let error {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testCurrentForecastRequestByAddressInvalidDataNoGeocoding() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given text address, no geocoding via Apple, but returns error")
        do {
            let data = try await apiManager.sendRequest(endpoint: .currentWithQuery(query: TestData.invalidLocation.locationAddress), responseModel:CurrentForecast.self)
            print("Data received: \(data)")

        } catch let error {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
}
