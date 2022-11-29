//
//  MainFilterReactor.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import RxSwift
//import ReactorKit
//
//class MainFilterReactor: Reactor {
//    
//    enum Action {
//        case findNeighborhood(data: KakaoRestAPIModel.AddressSearch.Document, radius: String)
//        case Unknown
//    }
//    
//    enum Mutation {
//        case updateNeighborhoodCount(count: Int)
//        case Unknown
//    }
//    
//    let initialState: State = State()
//    
//    struct State {
//        var neighborhoodCount: Int = 0
//    }
//    
//    var isEnd: Bool = false
//    var tempList: [KakaoRestAPIModel.KeywordSearch.Document] = []
//    
//}
//
//extension MainFilterReactor {
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        
//        case let .findNeighborhood(data, radius):
//            
//            return Observable.of(1,2,3)
//                .take(while: { [weak self] _ in
//                    guard let `self` = self else { return false }
//                    return !self.isEnd
//                })
//                .flatMap { page -> Observable<KakaoRestAPIModel.KeywordSearch> in
//                    return App.api.keywordSearch(page: page, xPoint: data.x, yPoint: data.y, radius: radius)
//                        .do(onNext: { [weak self] model in
//                            self?.tempList += model.documents
//                            self?.isEnd = model.meta.isEnd
//                            DEBUG_LOG("model.meta.isEnd: \(model.meta.isEnd)")
//                        })
//                }
//                .map { $0.meta.pageableCount }
//                .flatMap { Observable.just(Mutation.updateNeighborhoodCount(count: $0)) }
//            
////            return App.api.keywordSearch(page: 1, xPoint: data.x, yPoint: data.y, radius: radius)
////                .map { return $0.meta.pageableCount }
////                .flatMap { Observable.just(Mutation.updateNeighborhoodCount(count: $0)) }
//            
//        case .Unknown: return Observable.empty()
//        
//        }
//    }
//    
//    func reduce(state: State, mutation: Mutation) -> State {
//        var newState = state
//        
//        switch mutation {
//        case let .updateNeighborhoodCount(count):
//            newState.neighborhoodCount = count
//            self.isEnd = false
//            DEBUG_LOG("self.tempList.count: \(self.tempList.count)")
//        case .Unknown: break
//        }
//        
//        return newState
//    }
//}
