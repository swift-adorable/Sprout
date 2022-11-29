//
//  SearchAddressReactor.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa
//import ReactorKit
//
//class SearchAddressReactor: Reactor {
//    enum Action {
//        case searchAddress(keyWord: String, page: Int)
//        case loadNextPage
//        case unknown
//    }
//    
//    enum Mutation {
//        case addressList(list: [KakaoRestAPIModel.AddressSearch.Document])
//        case loadMoreList(list: [KakaoRestAPIModel.AddressSearch.Document])
//    }
//    
//    let initialState: State = State()
//    
//    struct State {
//        var addressList: [KakaoRestAPIModel.AddressSearch.Document] = []
//        var isEnd: Bool = true
//    }
//    
//    var keyWord = ""
//    var page = 1
//    
//}
//
//extension SearchAddressReactor {
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        
//        case let .searchAddress(keyWord, page):
//            guard let encodedKeyWord = keyWord.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else { return Observable.empty() }
//            self.keyWord = encodedKeyWord
//            return App.api.addressSearch(word: encodedKeyWord, page: page)
//                .map { $0.documents }
//                .flatMap { Observable.just(Mutation.addressList(list: $0)) }
//            
//        case .loadNextPage:
//            self.page += 1
//            return App.api.addressSearch(word: self.keyWord, page: page)
//                .map { $0.documents }
//                .flatMap { Observable.just(Mutation.loadMoreList(list: $0)) }
//            
//        case .unknown: return Observable.empty()
//        }
//    }
//    
//    func reduce(state: State, mutation: Mutation) -> State {
//        var returnState = state
//        
//        switch mutation {
//
//        case let .addressList(list):
//            returnState.addressList = list
//            
//        case let.loadMoreList(list):
//            returnState.addressList += list
//        }
//        
//        return returnState
//    }
//}
