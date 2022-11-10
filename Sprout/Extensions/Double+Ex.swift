//
//  Double+Ex.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation

extension Double {
    var degreeToRadians: Double {
        return self * .pi / 180
    }
    
    var radiansToDegree: Double {
        return self * 180 / .pi
    }
}
