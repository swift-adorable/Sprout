//
//  UIImageView+Rx.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/16.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

extension Reactive where Base: UIImageView {
    var setImage: Binder<Photo?> {
        return Binder(base) { (imageView, value) in
            guard let value = value else { return }
            let isGIFPhoto = value.url.absoluteString.contains("GIF")

            if isGIFPhoto {
                imageView.kf.setImage(with: value.url, completionHandler:  { result in
                    switch result {
                    case .success(_): break
                    case .failure(_): imageView.image = UIImage(data: value.data.origin)
                    }
                })
            } else {
                imageView.image = UIImage(data: value.data.origin)
            }
        }
    }
}
