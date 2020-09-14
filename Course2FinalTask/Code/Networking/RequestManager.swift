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
    static var shared = RequestManager()
    
    func getRequest(url: URL) {
           guard let token = Keychain.shared.readToken() else { print("no token"); return  }
           
           let defaultHeaders = [
               "Content-Type" : "application/json",
               "token" : token
           ]
           
           var request = URLRequest(url: url)
           request.allHTTPHeaderFields = defaultHeaders
          
       }
}
