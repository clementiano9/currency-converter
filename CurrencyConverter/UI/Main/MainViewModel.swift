//
//  MainViewModel.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - MainViewModel

class MainViewModel {
    private var service: ApiServiceDelegate
    private var delegate: MainViewDisplayLogic
    
    private var bag = DisposeBag()
    
    var symbols: [String: String] = [:] // The currencys available
    private var sortedSymbolKeys = [String]()   // Stores the symbols keys in a sorted manner
    
    private (set) var rates: [String : Double] = [:]  // Conversion rates 
    let fromCurrency = BehaviorRelay<String>(value: "")
    let toCurrenccy = BehaviorRelay<String>(value: "")
    
    var fromValue: String = ""
    var toValue = ""
    
    // Subscriptions
    var _symbolsSubscription: Disposable? = nil
    
    init(delegate: MainViewDisplayLogic, service: ApiServiceDelegate = ApiService()) {
        self.delegate = delegate
        self.service = service
        
        fromCurrency.subscribe { [weak self] in
            guard !($0.element?.isEmpty ?? false) else { return }
            self?.fetchLatestRate()
        }.disposed(by: bag)
        
        toCurrenccy.subscribe { [weak self] _ in
            self?.convert()
        }.disposed(by: bag)
    }
    
    /// Access the symbols dictionary via index
    /// - Parameter pos: the index
    /// - Returns: the key for the currency accessed in a sorted manner
    func getSymbolAtIndex(pos: Int) -> String? {
        if sortedSymbolKeys.indices.contains(pos) {
            return sortedSymbolKeys[pos]
        }
        return nil
    }
    
    /// Fetch symbols/currencies
    func getSymbols() {
        delegate.mainDataLoading()
        _symbolsSubscription = service.getSymbols()
            .subscribe { [weak self] response in
                if (response.success) {
                    self?.symbols = response.symbols
                    // Store symbol keys in sorted order for sorted list access
                    self?.sortedSymbolKeys = response.symbols.keys.sorted()
                    self?.delegate.mainDataLoadingSuccess()
                } else {
                    print("Error fetching symbols")
                    self?.delegate.mainDataLoadingFailure(error: ErrorResponse.custom("Unable to fetch data"))
                }
            } onError: { [weak self] error in
                print("Error fetching symbolds: \(error.localizedDescription)")
                self?.delegate.mainDataLoadingFailure(error: error)
            }
        
        _symbolsSubscription?.disposed(by: bag)

    }
    
    /// Fetch the latest conversion rate base on the currency stored in `fromCurrency`
    private func fetchLatestRate() {
        service.getLatestRates(base: fromCurrency.value)
            .subscribe { [weak self] in
                if ($0.success) {
                    self?.rates = $0.rates
                    self?.convert()
                } else {
                    print("Error fetching latest currencies")
                }
            } onError: { error in
                print("Error fetching latest currencies: \(error.localizedDescription)")
            }.disposed(by: bag)

    }
    
    
    /// Set the amount to be converted and execute `convert`
    /// - Parameter value: the amount to be converted
    func setSourceValue(_ value: String) {
        fromValue = value
        convert()
    }
    
    /// Compute validation and execute `calculateConversion`
    private func convert() {
        if !fromCurrency.value.isEmpty && !toCurrenccy.value.isEmpty {
            let source = fromCurrency.value
            let dest = toCurrenccy.value
            let amount = calculateConversion(value: fromValue, from: source, to: dest)
            delegate.conversionFinished(amount: amount)
        }
    }
    
    private func calculateConversion(value: String, from source: String, to target: String) -> String {
        guard !value.isEmpty else { return "" }
        
        print("Converting \(value) from \(source) to \(target)")
        
        // Check if the exchange rate is defined in the dictionary
        guard let exchangeRate = rates[target], let value = Double(value) else {
            return ""
        }

        return (value * exchangeRate).description
    }
    
    func switchCurrencies() {
        let hold = fromCurrency.value
        fromCurrency.accept(toCurrenccy.value)
        toCurrenccy.accept(hold)        
    }
}
