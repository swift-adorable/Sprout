//
//  Router.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

struct API {
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    static func logDecodingError(error: DecodingError){
        switch error {
            
        case let .typeMismatch(type, context):
            DEBUG_LOG("[typeMismatch] type: \(type), context: \(context)")

        case let .valueNotFound(codingKey, context):
            DEBUG_LOG("[valueNotFound] codingKey: \(codingKey), context: \(context)")

        case let .keyNotFound(codingKey, context):
            DEBUG_LOG("[keyNotFound] codingKey: \(codingKey), context: \(context)")

        case let .dataCorrupted(context):
            DEBUG_LOG("[dataCorrupted] context: \(context)")

        @unknown default: return
            
        }
    }
    
}

extension API {
    
    //MARK: 주소 검색
    func addressSearch(word: String, page: Int) -> Observable<KakaoRestAPIModel.AddressSearch> {
        
        return Router.addressSearch(word: word, page: page).buildRequest()
            .flatMap { data -> Observable<KakaoRestAPIModel.AddressSearch> in
                do {
                    let data = try self.decoder.decode(KakaoRestAPIModel.AddressSearch.self, from: data)
                    return Observable.just(data)
                } catch(let error) {
                    return Observable.error(error)
                }
            }
    }
    
    //MARK: 키워드로 주소 검색
    func keywordSearch(page: Int, xPoint: String, yPoint: String, radius: String) -> Observable<KakaoRestAPIModel.KeywordSearch> {
        
        return Router.keywordSearch(page: page, xPoint: xPoint, yPoint: yPoint, radius: radius)
            .buildRequest()
            .flatMap { data -> Observable<KakaoRestAPIModel.KeywordSearch> in
                do {
                    let data = try self.decoder.decode(KakaoRestAPIModel.KeywordSearch.self, from: data)
                    return Observable.just(data)
                } catch(let error) {
                    return Observable.error(error)
                }
            }
    }
    
    //MARK: 좌표를 주소로 변환
    func coord2Address(xPoint: String, yPoint: String) -> Observable<KakaoRestAPIModel.Coord2Address> {
        
        return Router.coord2Address(xPoint: xPoint, yPoint: yPoint)
            .buildRequest()
            .flatMap { data -> Observable<KakaoRestAPIModel.Coord2Address> in
                do {
                    let data = try self.decoder.decode(KakaoRestAPIModel.Coord2Address.self, from: data)
                    return Observable.just(data)
                } catch(let error) {
                    return Observable.error(error)
                }
            }
    }
    
}

//MARK: random word
extension API {
    func randomWord(nums: Int, _ completion: @escaping ([String]) -> Void) {
        
        guard let url = URL(string: "https://random-word.ryanrk.com/api/en/word/random/\(nums)") else { return }
        
        let request = AF.request(url)
            
        request.responseData { (dataResponse) in
//                    DEBUG_LOG(dataResponse.debugDescription)
//                    DEBUG_LOG("statusCode: \(dataResponse.response?.statusCode ?? 100)")
            
            if let data = dataResponse.data {
                do {
                    let data = try self.decoder.decode([String].self, from: data)

                    completion(data)
                    
                } catch(let error) {
                    DEBUG_LOG("random word error: " + error.localizedDescription )
                }
                
            } else {
                if dataResponse.error != nil {
                    DEBUG_LOG("random word error: " + (dataResponse.error?.localizedDescription ?? "") )
                }
            }
        }
        
    }
}
