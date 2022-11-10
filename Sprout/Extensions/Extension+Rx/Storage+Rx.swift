//
//  Storage.swift
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

enum StorageName {
    case license
    case profile
    case post
    case message
    case uid
}

extension Reactive where Base: StorageReference {
    public func uploadProfileImage(photoData: Data) -> Observable<String> {
        guard photoData.count > 0 else { return Observable.empty() }
        
        return Observable.create { obs in
            
            let storageRef = self.base.child("profile_images").child(NSUUID().uuidString)

            storageRef.putData(photoData, metadata: nil, completion: { (_, err) in
                if let err = err {
                    DEBUG_LOG("Storage Profile Image putData Failed: \(err.localizedDescription)")
                    obs.onError(err)
                }

                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        DEBUG_LOG("Storage Profile Image downloadURL Failed: \(err.localizedDescription)")
                        obs.onError(err)
                    } else if let profileImageUrl = downloadURL?.absoluteString {
                        DEBUG_LOG("Storage Profile Image Upload Success")
                        obs.onNext(profileImageUrl)
                        obs.onCompleted()
                    }
                    
                })
            })
            
            return Disposables.create()
        }
        
    }
}
