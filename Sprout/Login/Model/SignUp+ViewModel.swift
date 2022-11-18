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
        let textField: Observable<(SignUpInputType, String?)>
        //let photo: Observable<[Photo]>
    }
        
    struct Output {
        let resultMessage: BehaviorSubject<String>
        let currentUserData: BehaviorSubject<User>
        //let profileImage: BehaviorSubject<Photo?>
        
        init() {
            resultMessage = BehaviorSubject(value: "")
            currentUserData = BehaviorSubject(value: User())
            //profileImage = BehaviorSubject(value: nil)
        }
        
    }
    
    private var user = BehaviorSubject<User>(value: User())
    
    var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.done.debug("ViewModel Test")
            .map { _ -> String in
                let randStr = ["1", "2", "3", "4"]
                let randNo = Int.random(in: 0 ..< 4)
                return randStr[randNo]
            }.subscribe(onNext: { [weak self] randNo in
                output.resultMessage.onNext(randNo)
                if let user = try? self?.user.value() {
                    output.currentUserData.onNext(user)
                }
            }).disposed(by: disposeBag)
        
        input.textField
            .subscribe(onNext: { [weak self] (textType, text) in
                guard let `self` = self else { return }
                guard var newValue = try? self.user.value() else { return }
                let text = text ?? ""
                switch textType {
                case .Email:
                    newValue.email = text
                case .Password:
                    newValue.password = text
                case .Nickname:
                    newValue.nickname = text
                case .DuplicatePassword:
                    newValue.password = text
                case .Unknown: break
                }
                self.user.onNext(newValue)
            }).disposed(by: disposeBag)
        
//        input.photo
//            .withLatestFrom(user) { ($0, $1) }
//            .subscribe(onNext: { [weak self] (photo, user) in
//                guard let photo = photo.first else { return }
//                var newValue = user
//                newValue.profileImage = photo
//                self?.user.onNext(newValue)
//                output.profileImage.onNext(photo)
//            }).disposed(by: disposeBag)
        
        return output
    }
    
}
