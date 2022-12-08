//
//  ApiServiceDelegate.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya
//

import Foundation
import RxSwift

protocol ApiServiceDelegate {
    /// Fetch all currencies supported
    func getSymbols() -> Observable<SymbolsResponse>
    
    /// Fetch latest rates for the base currency
    func getLatestRates(base: String) -> Observable<LatestRatesResponse>
}
