//
//  UITextField+Ex.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/17.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

extension UITextField {

    func setPaddingLeft(constant: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: constant, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
