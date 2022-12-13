//
//  DetailsViewModel.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation
import RxSwift

class DetailsViewModel {
    private var service: ApiServiceDelegate
    private var delegate: DetailsViewDisplayLogic
    
    private var bag = DisposeBag()
    
    var data: [HistoricalRate] = []
    
    init(delegate: DetailsViewDisplayLogic, service: ApiServiceDelegate = ApiService()) {
        self.delegate = delegate
        self.service = service
    }
    
    /// Fetches historical rates data for previous 3 days by executing multiple observable calls at the same time
    func getHistoricalData(source: String, target: String) {
        self.delegate.detailsLoading()
        let list: [Observable<HistoricalRate>] = createListOfObservables(source: source, target: target)
        
        Observable.zip(list).subscribe {
            self.data = $0
            self.delegate.detailsSuccess()
        } onError: {
            self.delegate.detailsLoadingFailure(error: $0)
        }.disposed(by: bag)
    }
    
    /// Creates a list of observable calls representing each a call to historical data endpoint for a specific date
    func createListOfObservables(source: String, target: String) -> [Observable<HistoricalRate>] {
        let dates = getThreePreviousDates()
        return dates.map({
            getHistoricalData(for: $0.formatDate(), source: source, target: target)
        })
    }
    
    private func getHistoricalData(for date: String, source: String, target: String) -> Observable<HistoricalRate> {
        return service.getHistoricalRate(base: source, target: target, date: date)
    }
    
    /// Generate last 3 days date
    private func getThreePreviousDates() -> [Date] {
        var dates = [Date]()
        for i in 0...2 {
            if let date = Calendar.current.date(byAdding: .day, value: -(i), to: Date()) {
                print(date)
                dates.append(date)
            }
        }
        return dates
    }
}
