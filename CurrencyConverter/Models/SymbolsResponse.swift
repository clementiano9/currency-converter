//
//  SymbolsResponse.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation
import ObjectMapper

// MARK: - Symbols
struct SymbolsResponse: Codable {
    let symbols: [String: String]
    let success: Bool
}


