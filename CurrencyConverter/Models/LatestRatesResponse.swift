//
//  LatestRatesResponse.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation

// MARK: - LatestRatesResponse
struct LatestRatesResponse: Codable {
    let base, date: String
    let rates: [String: Double]
    let success: Bool
    let timestamp: Int
}
