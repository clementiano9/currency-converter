//
//  ErrorResponse.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation

enum ErrorResponse: Error {
    case noInternet
    case custom(String)
}

extension ErrorResponse: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No internet connection found"
        case .custom(let message):
            return message
        }
    }
}
