//
//  APIManager.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import Foundation
import Combine
import CoreLocation // we need it for CLGeocoder

protocol APIManagerProtocol
{
}

public class APIManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, APIManagerProtocol
{
    static var requestTimeOut:Float = 15.0
    static let shared = APIManager() // it's not as much in fashion to use singletons
    
    lazy var urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    let decoder: JSONDecoder = {
        let retval = JSONDecoder()
        retval.keyDecodingStrategy = .useDefaultKeys
        return retval
    }()
    
    // TODO: Fill out API network calls
    
    // MARK: - Core methods
    
    func request<T: Codable>(_ req: URLRequest) -> AnyPublisher<T, NetworkError> {
        let sessionConfig = URLSessionConfiguration.default
         sessionConfig.timeoutIntervalForRequest = TimeInterval(APIManager.requestTimeOut)
        
        let urlSession = URLSession(configuration: URLSession.shared.configuration, delegate: nil, delegateQueue: URLSession.shared.delegateQueue)
        
        return urlSession
            .dataTaskPublisher(for: req)
            .tryMap { output in
                if let response = output.response as? HTTPURLResponse,
                                   !(200...299).contains(response.statusCode) { // flesh this out, Nick
                    throw NetworkError.apiError(code: response.statusCode, error: "API Error")
                                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return NetworkError.invalidJSON(String(describing: error))
            }
            .eraseToAnyPublisher()
    }
}
