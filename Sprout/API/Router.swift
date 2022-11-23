//
//  KakaoRestAPI.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum Router {
    case addressSearch(word: String, page: Int)
    case keywordSearch(page: Int, xPoint: String, yPoint: String, radius: String)
    case coord2Address(xPoint: String, yPoint: String)
}

extension Router {
    
    static let baseURLString = "https://dapi.kakao.com/v2/local"
    
    static let headers: HTTPHeaders = ["Authorization" : "KakaoAK d04b22c25b4b214114f4afeebf2c12a5"]
    
    static let httpMethod: Alamofire.HTTPMethod = .get
    
    static let paramEncoding: ParameterEncoding = URLEncoding.default
    
    static let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }()
    
    var path: String {
        switch self {
        case let .addressSearch(word, page):
            return "/search/address.json?analyze_type=similar&size=30&query=\(word)&page=\(page)"
            
        case let .keywordSearch(page, xPoint, yPoint, radius):
            let word: String = "%EB%8F%99%EC%82%AC%EB%AC%B4%EC%86%8C" // Encoded Word: "동사무소"
            return "/search/keyword.json?page=\(page)&size=15&sort=distance&query=\(word)&category_group_code=PO3&x=\(xPoint)&y=\(yPoint)&radius=\(radius)"
            
        case let .coord2Address(xPoint, yPoint):
            return "/geo/coord2address.json?input_coord=WGS84&x=\(xPoint)&y=\(yPoint)"
        }
    }
    
    var url: URL {
        let urlString = Router.baseURLString + self.path
        return try! urlString.asURL()
    }
    
}

extension Router {
    
    func buildRequest(parameters: Parameters = [:]) -> Observable<Data> {
        
        DEBUG_LOG("buildRequest URL: \(self.url.absoluteString)")
                
        return Observable<Data>.create{ (anyObserver) -> Disposable in
            
            let request = AF.request(self.url,
                                     method: Router.httpMethod,
                                     parameters: parameters,
                                     encoding: Router.paramEncoding,
                                     headers: Router.headers)
                
                .responseData(completionHandler: { (dataResponse) in
//                    DEBUG_LOG(dataResponse.debugDescription)
//                    DEBUG_LOG("statusCode: \(dataResponse.response?.statusCode ?? 100)")
                    
                    if let data = dataResponse.data {
                        anyObserver.onNext(data)
                        anyObserver.onCompleted()
                    }else{
                        if let error = dataResponse.error {
                            let alert: UIAlertController = UIAlertController(title: "새싹", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
//                            App.delegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                            anyObserver.onError(error)
                        }
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
