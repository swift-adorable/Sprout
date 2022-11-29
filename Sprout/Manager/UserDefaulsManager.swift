//
//  UserDefaulsManager.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/29.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import RxSwift

//MARK: - UserDefaults + Extension -

extension UserDefaults {
    
    fileprivate func update(of key: UserDefaultsManager.Keys, property: GenericProperty<Any>) {
        guard !property.isCodable else {
            self.set(property.encodedValue(), forKey: key.rawValue)
            UserDefaultsManager.shared.value.onNext(key)
            return
        }
        self.set(property.value, forKey: key.rawValue)
        UserDefaultsManager.shared.value.onNext(key)
        return
    }
    
}

//MARK: - UserDefaults Manager -

final class UserDefaultsManager: ReactiveCompatible {
    
    static let shared: UserDefaultsManager = UserDefaultsManager()
    
    fileprivate static let standard = UserDefaults.standard
    
    fileprivate var value: BehaviorSubject<Keys> = BehaviorSubject(value: .unknown)
    
}

extension Reactive where Base: UserDefaultsManager {
    
    func value(of key: UserDefaultsManager.Keys) -> Observable<GenericProperty<Any>> {
        
        return Base.shared.value.asObserver()
            //.debug("Base.shared.value.asObserver")
            .filter { $0 == key }
            .flatMap { (key) -> Observable<GenericProperty<Any>> in
                guard let object = Base.standard.object(forKey: key.rawValue) else {
                    return .empty()
                }
                
                guard !(key.isCodableData) else {
                    if let data = Base.standard.object(forKey: key.rawValue) as? Data, let type = key.type,
                       let decoded = try? JSONDecoder().decode(type, from: data) {
                        return Observable.just(GenericProperty(decoded))
                    }
                    
                    return .empty()
                }
                
                return Observable.just(GenericProperty(object))
            }
        
    }
    
    var update: Binder<(Base.Keys, GenericProperty<Any>)> {
        Binder(Base.standard) { (shared, arg) in
            let (key, property) = arg
            //DEBUG_LOG("UserDefaults update key: \(key), value: \(String(describing: property.value))")
            shared.update(of: key, property: property)
        }
    }
    
}

//MARK: - UserDefaultsManager Keys -

extension UserDefaultsManager {
    
    enum Keys: String, CaseIterable {
        case user
        case unknown
    }
    
}

extension UserDefaultsManager.Keys {
    
    var isCodableData: Bool {
        switch self {
        case .user:
            return true
        case .unknown:
            return false
        }
    }
    
    var type: Codable.Type? {
        switch self {
        case .user:
            return User.self
        case .unknown:
            return nil
        }
    }
    
}
