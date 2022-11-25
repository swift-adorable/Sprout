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
        let textFieldText: Observable<(SignUpInputType, String?)>
        let agreementState: Observable<[TermsOfServiceType: Bool]>
        //let photo: Observable<[Photo]>
    }
        
    struct Output {
        let resultMessage: BehaviorSubject<String>
        let currentUserData: BehaviorSubject<User>
        let errorMessage: BehaviorSubject<(SignUpInputType, String?)>
        //let profileImage: BehaviorSubject<Photo?>
        
        init() {
            resultMessage = BehaviorSubject(value: "")
            errorMessage = BehaviorSubject(value: (.Email, ""))
            currentUserData = BehaviorSubject(value: User())
            //profileImage = BehaviorSubject(value: nil)
        }
        
    }
    
    fileprivate var user = BehaviorSubject<User>(value: User())
    
    var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.done
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
        
        let textFieldTextWithUser = input.textFieldText
            .withLatestFrom(user) { ($0, $1) }
            .share()
        
        textFieldTextWithUser
            .map { (arg0, user) -> (SignUpInputType, String) in
                let textType = arg0.0

                guard let text = arg0.1 else { return (textType, "") }
                if (textType == .DuplicatePassword) && !user.password.isEmpty && text != user.password {
                    return (textType, "비밀번호가 일치하지 않습니다.")
                }
                
                if !text.checkRegularExpression(with: textType.regexPattern) {
                    return (textType, textType.errorWithCheckRegex)
                }
                
                return (textType, "")
            }.bind(to: output.errorMessage)
            .disposed(by: disposeBag)
        
        textFieldTextWithUser
            .map { (arg0, user) -> User in
                let textType = arg0.0
                guard let text = arg0.1 else { return user }
                var newValue = user
                return newValue.update(type: textType, value: text)
            }.bind(to: user)
            .disposed(by: disposeBag)
        
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
