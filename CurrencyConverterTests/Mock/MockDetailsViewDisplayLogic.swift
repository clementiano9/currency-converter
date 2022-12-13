//
//  MockDetailsViewDisplayLogic.swift
//  CurrencyConverterTests
//
//  Created by Clement Ozemoya.
//

import Foundation
@testable import CurrencyConverter

class MockDetailsViewDisplayLogic: DetailsViewDisplayLogic {
    var success = false
    var error: Error? = nil
    
    func detailsLoading() {
        error = nil
    }
    
    func detailsSuccess() {
        success = true
    }
    
    func detailsLoadingFailure(error: Error) {
        success = false
        self.error = error
    }
}
