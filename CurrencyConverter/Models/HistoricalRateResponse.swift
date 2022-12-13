//
//  HistoricalRateResponse.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation

// MARK: - HistoricalRate
struct HistoricalRate: Codable {
    let base, date: String
    let historical: Bool
    let rates: [String: Double]
    let success: Bool
    let timestamp: Int
}

