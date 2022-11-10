//
//  UIColor+Ex.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    static func colorFromRGB(_ rgbValue: UInt, alpha : CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha: alpha)
    }
    
    static let signature = UIColor(named: "Signature")!
    
    static let signatureNWhite = UIColor(named: "SignatureNWhite")!
    
    static let whiteNBlack = UIColor(named: "WhiteNBlack")!
    
    static let blackNWhite = UIColor(named: "BlackNWhite")!
    
}
