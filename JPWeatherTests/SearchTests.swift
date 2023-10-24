//
//  NetworkHandlerTests.swift
//  JPWeatherTests
//
//  Created by Nicolas Dedual on 10/24/23.
//

import XCTest
@testable import JPWeather

final class SearchTests: XCTestCase
{
    var apiManager = APIManager.shared
    
    func testValidSearch() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given location")
        do {
            let data = try await apiManager.getTempLocationsInfoFromQuery(address: TestData.harlem.locationAddress)
            print("Data received: \(data)")
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testValidSearchMultipleResults() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given location")
        do {
            let data = try await apiManager.getTempLocationsInfoFromQuery(address: TestData.veniceUncertain.locationAddress)
            
            XCTAssertTrue(data.count > 1)
            print("Data received: \(data)")
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testValidSearchNoResults() async
    {
        let expectation = XCTestExpectation(description: "Perform network request with given location")
        do {
            let data = try await apiManager.getTempLocationsInfoFromQuery(address: TestData.invalidLocation.locationAddress)
            
            XCTAssertTrue(data.count == 0)
            print("Data received: \(data)")
            expectation.fulfill()
        } catch let error {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }

}
