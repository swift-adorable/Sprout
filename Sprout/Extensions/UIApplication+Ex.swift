//
//  UIApplication+Ex.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import Foundation

extension UIApplication {

    static func isNetworkActivityIndicator(_ onOff: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = onOff
        }
    }
    
}
