//
//  ApiEndpoints.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya
//

import Foundation

fileprivate let BASE_URL = "https://api.apilayer.com/fixer"

/// Represents every endpoint available to ApiServices
enum ApiEndpoints: String {
    case symbols = "/symbols"
    case latestRates = "/latest"
    case historicalRate = ""
}

extension ApiEndpoints {
    /// Generate the full endpoint url
    var url: String {
        get {
            return "\(BASE_URL)\(rawValue)"
        }
    }
}
