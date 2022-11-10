//
//  StarRateLayers.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

class StarRateLayers {
    /**

    Creates the layers for the stars.

    - parameter rating: The decimal number representing the rating. Usually a number between 1 and 5
    - parameter settings: Star view settings.
    - returns: Array of star layers.

    */
    class func createStarLayers(_ rating: Double, settings: StarRateSettings, isRightToLeft: Bool) -> [CALayer] {

        var ratingRemander = StarRating.numberOfFilledStars(rating, totalNumberOfStars: settings.totalStars)

        var starLayers = [CALayer]()

        for _ in (0..<settings.totalStars) {

            let fillLevel = StarRating.starFillLevel(ratingRemainder: ratingRemander, fillMode: settings.fillMode)

            let starLayer = createCompositeStarLayer(fillLevel, settings: settings, isRightToLeft: isRightToLeft)
            starLayers.append(starLayer)
            ratingRemander -= 1
        }

        if isRightToLeft { starLayers.reverse() }
        positionStarLayers(starLayers, starMargin: settings.starMargin)
        return starLayers
    }


    /**

    Creates an layer that shows a star that can look empty, fully filled or partially filled.
    Partially filled layer contains two sublayers.

    - parameter starFillLevel: Decimal number between 0 and 1 describing the star fill level.
    - parameter settings: Star view settings.
    - returns: Layer that shows the star. The layer is displayed in the cosmos view.

    */
    class func createCompositeStarLayer(_ starFillLevel: Double, settings: StarRateSettings, isRightToLeft: Bool) -> CALayer {
        
        if starFillLevel >= 1 {
            return createStarLayer(.full, isFilled: true, settings: settings)
        }
        
        if starFillLevel == 0 {
            return createStarLayer(.empty, isFilled: false, settings: settings)
        }

        return createPartialStar(starFillLevel, settings: settings, isRightToLeft: isRightToLeft)
    }

    /**

    Creates a partially filled star layer with two sub-layers:

    1. The layer for the filled star on top. The fill level parameter determines the width of this layer.
    2. The layer for the empty star below.

    - parameter starFillLevel: Decimal number between 0 and 1 describing the star fill level.
    - parameter settings: Star view settings.

    - returns: Layer that contains the partially filled star.

    */
    class func createPartialStar(_ starFillLevel: Double, settings: StarRateSettings, isRightToLeft: Bool) -> CALayer {
        let fullStar = createStarLayer(.full, isFilled: true, settings: settings)
        let halfStar = createStarLayer(.half, isFilled: true, settings: settings)
        let emptyStar = createStarLayer(.empty, isFilled: false, settings: settings)

        let parentLayer = CALayer()
        parentLayer.contentsScale = UIScreen.main.scale
        parentLayer.bounds = CGRect(origin: CGPoint(), size: fullStar.bounds.size)
        parentLayer.anchorPoint = CGPoint()
        parentLayer.addSublayer(emptyStar)
        parentLayer.addSublayer(halfStar)
        parentLayer.addSublayer(fullStar)

        if isRightToLeft {
            // Flip the star horizontally for a right-to-left language
            let rotation = CATransform3DMakeRotation(CGFloat(Double.pi), 0, 1, 0)
            fullStar.transform = CATransform3DTranslate(rotation, -fullStar.bounds.size.width, 0, 0)
        }

        // Make filled layer width smaller according to the fill level
        fullStar.bounds.size.width *= CGFloat(starFillLevel)

        return parentLayer
    }

    private class func createStarLayer(_ starImage: StarFillImage, isFilled: Bool, settings: StarRateSettings) -> CALayer {
        // Create a layer that shows a star from an image
        
        if starImage == .full, let image = settings.fullImage {
            return StarLayer.create(image: image, size: settings.starSize)
            
        } else if starImage == .half, let image = settings.halfImage {
            return StarLayer.create(image: image, size: settings.starSize)
            
        } else if starImage == .empty, let image = settings.emptyImage {
            return StarLayer.create(image: image, size: settings.starSize)
        }

        // Create a layer that draws a star from an array of points

        let fillColor = isFilled ? settings.filledColor : settings.emptyColor
        let strokeColor = isFilled ? settings.filledBorderColor : settings.emptyBorderColor
        
        return StarLayer.create(settings.starPoints, size: settings.starSize,
                                lineWidth: isFilled ? settings.filledBorderWidth : settings.emptyBorderWidth,
                                fillColor: fillColor, strokeColor: strokeColor)
    }

    /**

    Positions the star layers one after another with a margin in between.

    - parameter layers: The star layers array.
    - parameter starMargin: Margin between stars.

    */
    class func positionStarLayers(_ layers: [CALayer], starMargin: Double) {
        var positionX:CGFloat = 0

        for layer in layers {
            layer.position.x = positionX
            positionX += layer.bounds.width + CGFloat(starMargin)
        }
    }
}
