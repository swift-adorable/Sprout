//
//  String+Ex.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation

extension String {
    func checkRegularExpression(with pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return false
        }
        let range = NSRange(location: 0, length: self.count)
        let matches = regex.matches(in: self, options: [], range: range)
        return matches.first != nil
    }
    
    var randomImageURL: URL? {
        return URL(string: "https://source.unsplash.com/random/?\(self)")
    }
    
}
