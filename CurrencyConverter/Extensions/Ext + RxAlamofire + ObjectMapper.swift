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
    /*public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            guard let (_, json) = data as? (HTTPURLResponse, Any),
             let object = Mapper<T>().map(JSONObject: json) else {
                throw NSError(
                    domain: "studio",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey : "Object mapper can't map this object"]
                )
            }
            return Observable.just(object)
        }
    }*/
    
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
    
    public func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return flatMap({ data -> Observable<[T]> in
            let json = data as AnyObject
            guard let objects = Mapper<T>().mapArray(JSONObject: json) else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey : "Unable to map this array"]
                )
            }
            return Observable.just(objects)
        })
    }
}
