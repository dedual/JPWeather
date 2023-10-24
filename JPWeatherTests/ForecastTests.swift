//
//  NetworkHandlerTests.swift
//  JPWeatherTests
//
//  Created by Nicolas Dedual on 10/24/23.
//

import XCTest
@testable import JPWeather

final class ForecastTests: XCTestCase
{
    var apiManager = APIManager.shared
    
    //MARK: - Current Forecast test functions 
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
        // normally we have this wrapped up and not accessed directly
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
    
    // MARK: - Multiday forecast test functions
    
    func testMultidayForecastRequestByLatLon() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given location")
        do {
            let data = try await apiManager.forecast(latitude: TestData.newyork.location.latitude, longitude: TestData.newyork.location.longitude)
            print("Data received: \(data)")
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testMultidayForecastRequestErrorBadInputData() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given location, but returns error")
        do {
            let data = try await apiManager.forecast(latitude: TestData.invalidLocation.location.latitude, longitude: TestData.invalidLocation.location.longitude)
            print("Data received: \(data)")
        } catch let error {
            print("⚠️\(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testMultidayForecastRequestByAddress() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given text address")
        do {
            let data = try await apiManager.forecast(address: TestData.newyork.locationAddress)
            print("Data received: \(data)")
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testMultidayForecastRequestByAddressNoGeocoding() async
    {
        // ensure we're testing OpenAPI's Weather by address query endpoint
        // normally we have this wrapped up and not accessed directly
        // but, as a result we've remembered that OpenWeather doesn't do street-level requests.
        // so, we need to account for that.
        let expectation = XCTestExpectation(description: "Perform network request with given text address, no geocoding via Apple")
        do {
            
            if let validAddress = apiManager.returnValidAddressQueryString(TestData.newyork.locationAddress)
            {
                let data = try await apiManager.sendRequest(endpoint: .forecastWithQuery(query: validAddress), responseModel:MultiDayForecast.self)
                print("Data received: \(data)")
            }
            else{
                let data = try await apiManager.sendRequest(endpoint: .forecastWithQuery(query: TestData.newyork.locationAddress), responseModel:MultiDayForecast.self)
                print("Data received: \(data)")
            }
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testMultidayForecastRequestByAddressInvalidData() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given text address, but returns error")
        do {
            let data = try await apiManager.forecast(address: TestData.invalidLocation.locationAddress)
            print("Data received: \(data)")

        } catch let error {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testMultidayForecastRequestByAddressInvalidDataNoGeocoding() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given text address, no geocoding via Apple, but returns error")
        do {
            let data = try await apiManager.sendRequest(endpoint: .currentWithQuery(query: TestData.invalidLocation.locationAddress), responseModel:MultiDayForecast.self)
            print("Data received: \(data)")

        } catch let error {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
}
