//
//  SignUp+ViewModel.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/15.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class SignUpViewModel: ViewModelType {
    
    struct Input {
        let done: Observable<Void>
    }
        
    struct Output {
        let resultMessage: BehaviorSubject<String>
        
        init() {
            resultMessage = BehaviorSubject(value: "")
        }
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.done.debug("ViewModel Test")
            .map { _ -> String in
                let randStr = ["1", "2", "3", "4"]
                let randNo = Int.random(in: 0 ..< 4)
                return randStr[randNo]
            }.bind(to: output.resultMessage)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
