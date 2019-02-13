//
//  Network.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import SwiftyJSON

private let baseUrl = "https://gist.githubusercontent.com/mohammadZ74/"

class APIManager {
    
    typealias Parameters = [String: Any]
    
    enum ApiResult {
        case success(JSON)
        case failure(RequestError)
    }
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    static func requestData(url: String,
                            method: HTTPMethod,
                            parameters: Parameters?,
                            completionHandler: @escaping (ApiResult) -> Void) {
        
        let header =  ["Content-Type": "application/x-www-form-urlencoded"]
        var urlRequest = URLRequest(url: URL(string: baseUrl+url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            let parameterData = parameters.reduce("") { (result, param) -> String in
                return result + "&\(param.key)=\(param.value as! String)"
                }.data(using: .utf8)
            urlRequest.httpBody = parameterData
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
                completionHandler(.failure(.connectionError))
            } else {
                guard let data = data, let res = response as? HTTPURLResponse else {
                    completionHandler(.failure(.unknownError))
                    return
                }
                do {
                    let json = try JSON(data: data)
                    print("responseJSON: \(json)")
                    switch res.statusCode {
                    case 200:
                        completionHandler(.success(json))
                    default:
                        completionHandler(.failure(.unknownError))
                    }
                } catch {
                    completionHandler(.failure(.unknownError))
                }
            }
        }.resume()
    }
}
