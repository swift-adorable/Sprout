//
//  UIView+Rx.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/22.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: UIView {
    var height: Binder<CGFloat> {
        return Binder(base) { (view, height) in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
//    var alert: Binder<String> {
//        return Binder(base) { viewController, message in
//            viewController.alert(message, msg: "")
//        }
//    }
//
}
