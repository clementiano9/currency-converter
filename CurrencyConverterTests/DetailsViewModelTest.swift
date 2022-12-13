//
//  DetailsViewModelTest.swift
//  CurrencyConverterTests
//
//  Created by Clement Ozemoya.
//

import XCTest
import RxSwift
@testable import CurrencyConverter
import RxTest

class DetailsViewModelTest: XCTestCase {

    let mockViewLogic = MockDetailsViewDisplayLogic()
    let mockApiService = MockApiService()
    
    lazy var sut: DetailsViewModel = {
        DetailsViewModel(delegate: mockViewLogic, service: mockApiService)
    }()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateObservableCalls() {
        let calls = sut.createListOfObservables(source: "EUR", target: "USD")
        
        XCTAssertEqual(calls.count, 3)
    }
    
    func testGetHistoricalData() {
        sut.getHistoricalData(source: "EUR", target: "USD")
        
        XCTAssertGreaterThan(sut.data.count, 0)
        XCTAssertTrue(mockViewLogic.success)
    }

    func testGetHistoricalDataFailure() {
        mockApiService.shouldFail = true
        sut.getHistoricalData(source: "EUR", target: "USD")
        
        XCTAssertEqual(sut.data.count, 0)
        XCTAssertFalse(mockViewLogic.success)
        XCTAssertNotNil(mockViewLogic.error)
    }
}
