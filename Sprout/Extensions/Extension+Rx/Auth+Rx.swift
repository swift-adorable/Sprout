//
//  Auth.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

extension Reactive where Base: Auth {
    
    //MARK: 이메일 로그인
    public func signIn(email: String, password: String) -> Observable<Bool> {
        return Observable.create { observer in
            self.base.signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    //DEBUG_LOG("Auth SignIn User Email failed: \(error.localizedDescription)")
                    observer.onError(error)
                } else if result?.user != nil {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    //MARK: 이메일 회원가입
    public func createUser(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.createUser(withEmail: email, password: password) { auth, error in
                if let error = error {
                    //DEBUG_LOG("Auth Create User failed: \(error.localizedDescription)")
                    observer.onError(error)
                } else if let auth = auth {
                    //DEBUG_LOG("Auth Create User Success")
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
}
