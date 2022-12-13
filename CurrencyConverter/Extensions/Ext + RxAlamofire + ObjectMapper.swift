//
//  Ext + RxAlamofire + ObjectMapper.swift
//  CurrencyConverter
//
//  Created by Clement Ozemoya
//

import Foundation
import RxSwift
import ObjectMapper
import RxAlamofire

extension ObservableType {
    
    public func mapObject<T: Codable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let decoder = JSONDecoder()
            guard let (_, json) = data as? (HTTPURLResponse, Any),
                  let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                  let object = try? decoder.decode(type, from: jsonData) else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey : "Unable to map this object"]
                )
            }
            return Observable.just(object)
        }
    }
}
