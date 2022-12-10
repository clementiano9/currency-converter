//
//  MainViewModelTest.swift
//  CurrencyConverterTests
//
//  Created by Clement Ozemoya.
//

import XCTest
import RxSwift
@testable import CurrencyConverter
import RxTest

class MainViewModelTest: XCTestCase {

    let mockViewLogic = MockMainViewDisplayLogic()
    let mockApiService = MockApiService()
    
    lazy var sut: MainViewModel = {
        MainViewModel(delegate: mockViewLogic, service: mockApiService)
    }()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetSymbolsFetchedSuccessfully() {
        sut.getSymbols()
        XCTAssertNil(self.mockViewLogic.error)
        XCTAssertGreaterThan(sut.symbols.count, 0)
    }
    
    func testGetSymbolsError() {
        mockApiService.shouldFail = true
        sut.getSymbols()
        XCTAssertNotNil(self.mockViewLogic.error)
        XCTAssertEqual(sut.symbols.count, 0)
    }
    
    func testSetSourceValue() {
        sut.setSourceValue("200")
        XCTAssertEqual("200", sut.fromValue)
    }
    
    func testGetRates() {
        sut.fromCurrency.accept("USD")
        XCTAssertGreaterThan(sut.rates.count, 0)
    }
}
