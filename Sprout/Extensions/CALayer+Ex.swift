//
//  CALayer+Ex.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    public func addBasicBorder(color: UIColor, width: CGFloat = 1, cornerRadius: CGFloat = 0) {
        self.borderWidth = width
        self.borderColor = color.cgColor
        self.cornerRadius = cornerRadius
    }
    
    func addBorder(_ arrEdge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arrEdge {
            let border = CALayer()

            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                border.frame = CGRect.zero
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
    
    public func addEachBoader(_ edge: [UIRectEdge], color: UIColor, width: CGFloat = 1) {
        edge.forEach {
            let border = CALayer()
            
            switch $0 {
            case .all:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
                border.backgroundColor = color.cgColor
                self.addSublayer(border)
                return
            
            case .top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                
            case .bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                
            case .left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)

            case .right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                
            default:
                border.frame = CGRect.zero
            }
            
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
