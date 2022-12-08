//
//  ApiService.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya.
//

import Foundation
import RxSwift
import RxAlamofire

class ApiService: ApiServiceDelegate {
    
    private var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Fixer-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Fixer-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Fixer-Info.plist'.")
        }
        return value
      }
    }
    
    func getSymbols() -> Observable<SymbolsResponse> {
        let url = ApiEndpoints.symbols.url
        return RxAlamofire.requestJSON(.get, url, headers: ["apikey": apiKey])
        .debug()
        .mapObject(type: SymbolsResponse.self)
    }
    
    func getLatestRates(base: String) -> Observable<LatestRatesResponse> {
        let url = ApiEndpoints.latestRates.url + "?base=\(base)"
        return RxAlamofire.requestJSON(.get, url, headers: ["apikey": apiKey])
        .debug()
        .mapObject(type: LatestRatesResponse.self)
    }
}
