//
//  UITextField+Rx.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {

    var textEditing: Binder<Void> {
        return Binder(base) { textField, _ in
            textField.text = ""
            textField.sendActions(for: .valueChanged)
        }
    }
}
