//
//  MockMainViewDisplayLogic.swift
//  CurrencyConverterTests
//
//  Created by Clement Ozemoya.
//

import Foundation
@testable import CurrencyConverter

class MockMainViewDisplayLogic: MainViewDisplayLogic {
    var isDataLoading = false
    var error: Error? = nil
    var convertedAmount: String? = nil
    
    func mainDataLoading() {
        isDataLoading = true
        error = nil
    }
    
    func mainDataLoadingFailure(error: Error) {
        isDataLoading = false
        self.error = error
    }
    
    func mainDataLoadingSuccess() {
        isDataLoading = false
    }
    
    func conversionFinished(amount: String) {
        convertedAmount = amount
    }
    
    func conversionFailed(error: Error) {
        self.error = error
    }
}
