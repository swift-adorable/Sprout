//
//  StarRateSize.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//
import UIKit

class StarRateSize {
    /**

    Calculates the size of the cosmos view. It goes through all the star and text layers and makes size the view size is large enough to show all of them.

    */
    class func calculateSizeToFitLayers(_ layers: [CALayer]) -> CGSize {
        var size = CGSize()

        for layer in layers {
            if layer.frame.maxX > size.width {
                size.width = layer.frame.maxX
            }

            if layer.frame.maxY > size.height {
                size.height = layer.frame.maxY
            }
        }

        return size
    }
}
