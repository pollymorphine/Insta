//
//  RequestManager.swift
//  Course2FinalTask
//
//  Created by Polina on 14.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

class RequestManager {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func getRequest(url: URL, paramBody: [String: String]? = nil) ->  URLRequest? {
        guard let token = Keychain.shared.readToken() else { print("no token"); return nil }
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        if let paramBody = paramBody,
            let httpBody = try? JSONSerialization.data(withJSONObject: paramBody, options: []) {
            request.httpBody = httpBody
            request.httpMethod = "POST"
        }
        return request
    }
    
    func getErrorResponce(httpResponse: URLResponse?) {
        guard let httpResponse = httpResponse as? HTTPURLResponse else { return  }
        let error: NetworkError
        
        switch httpResponse.statusCode {
        case 400: error = .badRequest(reason: "Bad Request")
        case 401: error = .unauthorized(reason: "Unathorized")
        case 404: error = .notFound(reason: "Not found")
        case 406: error = .notAcceptable(reason: "Not acceptable")
        case 422: error = .unprocessable(reason:  "Unprocessable")
        default: error = .transferError(reason:  "Transfer error")
        }
    }
}

