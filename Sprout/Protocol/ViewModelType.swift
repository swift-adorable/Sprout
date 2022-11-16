//
//  ViewModelType.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/15.
//

import RxSwift

public protocol ViewModelType: AnyObject {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(_ input: Input) -> Output
    
}
