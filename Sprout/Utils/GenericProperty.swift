//
//  GenericProperty.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/29.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation

final class GenericProperty<T> {
    private var v: T?
    
    init? () { }
    
    init (_ value: T) {
        self.v = value
    }
    
    var value: T? {
        return v
    }
    
    var valueType: String {
        return String(describing: T.self)
    }
    
    var isCodable: Bool {
        return value is Codable
    }
    
    func encodedValue() -> Data? {
        guard let codable = value as? Codable else {
            return nil
        }
        return try? JSONEncoder().encode(codable)
    }
    
}
