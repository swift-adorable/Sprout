//
//  Database+Rx.swift
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

extension Reactive where Base: DatabaseReference {
    public func uploadUserInfo(uid: String, nickname: String, profileImageUrl: String) -> Observable<Bool> {
        
        let userDict: [String:String] = ["uid": uid,
                                         "nickname": nickname,
                                         "profile_image_url": profileImageUrl]
        
        return Observable.create { observer in
            
            self.base.child("user_information").updateChildValues(["mentor":userDict]) { (error, ref) in
                if let error = error {
                    //DEBUG_LOG("Database User Information updateChildValues: \(error.localizedDescription)")
                    observer.onError(error)
                } else {
                    //DEBUG_LOG("Database User Information Upload Success")
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
}
