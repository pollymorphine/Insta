//
//  NetworkErrors.swift
//  Course2FinalTask
//
//  Created by Polina on 12.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case badRequest(reason: String)
    case unauthorized(reason: String)
    case notFound(reason: String)
    case notAcceptable(reason: String)
    case unprocessable(reason: String)
    case transferError(reason: String) 
    
    var error: String {
     switch self {
       case .notFound: return "Not found"
       case .badRequest: return "Bad request"
       case .unauthorized: return "Unauthorized"
       case .notAcceptable: return "Not acceptable"
       case .unprocessable: return "Incorrect login or password!"
       case .transferError: return "Transfer error"
     }
   }

}
