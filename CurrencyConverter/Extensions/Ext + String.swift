//
//  Ext + String.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
}
