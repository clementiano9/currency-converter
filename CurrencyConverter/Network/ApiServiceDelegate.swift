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
    
    /// Fetch historical rate
    func getHistoricalRate(base: String, target: String, date: String) -> Observable<HistoricalRate>
}
