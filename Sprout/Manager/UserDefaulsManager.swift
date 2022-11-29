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
        
        let updateValue = property.isCodable ? property.encodedValue() : property.value
        self.set(updateValue, forKey: key.rawValue)
    }
    
}

//MARK: - UserDefaults Manager -

final class UserDefaultsManager: ReactiveCompatible {
    
    static let shared: UserDefaultsManager = UserDefaultsManager()
    
    fileprivate static let standard = UserDefaults.standard
    
    fileprivate var value: BehaviorSubject<Keys> = BehaviorSubject(value: .unknown)
    
    func value(of key: UserDefaultsManager.Keys) -> GenericProperty<Any>? {
        
        guard let object = UserDefaultsManager.standard.object(forKey: key.rawValue) else {
            return nil
        }
        
        guard !(key.isCodableData) else {
            if let data = object as? Data, let type = key.type,
               let decoded = try? JSONDecoder().decode(type, from: data) {
                return GenericProperty(decoded)
            }
            
            return nil
        }
        
        return GenericProperty(object)
    }
    
}

extension Reactive where Base: UserDefaultsManager {
    
    func value(of key: UserDefaultsManager.Keys) -> Observable<GenericProperty<Any>> {
        
        return Base.shared.value.asObserver()
            //.debug("Base.shared.value.asObserver")
            .filter { $0 == key }
            .flatMap { (key) -> Observable<GenericProperty<Any>> in
                guard let value = Base.shared.value(of: key) else {
                    return .empty()
                }
                return Observable.just(value)
            }
        
    }
    
    var update: Binder<(Base.Keys, GenericProperty<Any>)> {
        Binder(Base.standard) { (standard, arg) in
            let (key, property) = arg
            //DEBUG_LOG("UserDefaults update key: \(key), value: \(String(describing: property.value))")
            standard.update(of: key, property: property)
            Base.shared.value.onNext(key)
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
