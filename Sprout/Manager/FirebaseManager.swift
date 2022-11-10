//
//  FirebaseManager.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import Firebase

final class FirebaseManager: NSObject {
    static let shared = FirebaseManager()
    
    let auth = Auth.auth()
    let cloudDB = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let realTimeDBRef = Database.database().reference()
    
    override init() { }
    
}
