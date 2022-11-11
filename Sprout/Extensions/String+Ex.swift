//
//  String+Ex.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation

extension String {
    func regularExpression() -> String {
        return ""
    }
    
    var randomImageURL: URL? {
        return URL(string: "https://source.unsplash.com/random/?\(self)")
    }
    
}
