//
//  MockApiService.swift
//  CurrencyConverterTests
//
//  Created by Clement Ozemoya on 08/12/2022.
//

import Foundation
import RxSwift
import XCTest

@testable import CurrencyConverter

class MockApiService: ApiServiceDelegate {
    var shouldFail = false
    var startedExpectation: XCTestExpectation? = nil
    var completionExpectation: XCTestExpectation? = nil
    
    func getSymbols() -> Observable<SymbolsResponse> {
        guard !shouldFail else {
            return Observable.error(ErrorResponse.custom("Failed"))
        }
        return Observable.just(
            SymbolsResponse(
                symbols: [
                    "NGN" : "Naira",
                    "EUR" : "Euros",
                    "GBP" : "GB Pounds",
                    "USD" : "US Dollars"
                ],
                success: true
            )
        ).`do`(onCompleted: {
            self.completionExpectation?.fulfill()
        }, onSubscribe: {
            self.startedExpectation?.fulfill()
        })
    }
    
    func getLatestRates(base: String) -> Observable<LatestRatesResponse> {
        guard !shouldFail else {
            return Observable.error(ErrorResponse.custom("Failed"))
        }
        return Observable.just(
            LatestRatesResponse(
                base: "EUR",
                date: "2022-12-07",
                rates: [
                    "NGN": 0.000592,
                    "GBP": 2.858111,
                    "USD": 2.858111
                ],
                success: true,
                timestamp: 1670419866
            )
        )
    }
}
