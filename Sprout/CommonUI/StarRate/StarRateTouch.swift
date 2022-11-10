//
//  StarRateTouch.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

/**

Functions for working with touch input.

*/
struct StarRateTouch {
    /**

    Calculates the rating based on the touch location.

    - parameter position: The horizontal location of the touch relative to the width of the stars.

    - returns: The rating representing the touch location.

    */
    static func touchRating(_ position: CGFloat, settings: StarRateSettings) -> Double {
        var rating = preciseRating(position: Double(position),
                                   numberOfStars: settings.totalStars,
                                   starSize: settings.starSize,
                                   starMargin: settings.starMargin)
        
        if settings.fillMode == .half {
            rating += 0.20
        }
        
        if settings.fillMode == .full {
            rating += 0.45
        }
        
        rating = StarRating.displayedRatingFromPreciseRating(rating,
                                                             fillMode: settings.fillMode,
                                                             totalStars: settings.totalStars)
        
        rating = max(settings.minTouchRating, rating) // Can't be less than min rating
            
        return rating
    }
  
  
    /**

    Returns the precise rating based on the touch position.

    - parameter position: The horizontal location of the touch relative to the width of the stars.
    - parameter numberOfStars: Total number of stars, filled and full.
    - parameter starSize: The width of a star.
    - parameter starSize: Margin between stars.
    - returns: The precise rating.

    */
    static func preciseRating(position: Double, numberOfStars: Int, starSize: Double, starMargin: Double) -> Double {

        if position < 0 { return 0 }
        var positionRemainder = position;

        // Calculate the number of times the star with a margin fits the position
        // This will be the whole part of the rating
        var rating: Double = Double(Int(position / (starSize + starMargin)))

        // If rating is grater than total number of stars - return maximum rating
        if Int(rating) > numberOfStars { return Double(numberOfStars) }

        // Calculate what portion of the last star does the position correspond to
        // This will be the added partial part of the rating

        positionRemainder -= rating * (starSize + starMargin)

        if positionRemainder > starSize {
            rating += 1
        } else {
            rating += positionRemainder / starSize
        }

        return rating
    }
}


/**

Helper function to make sure bounds are big enought to be used as touch target.
The function is used in pointInside(point: CGPoint, withEvent event: UIEvent?) of UIImageView.

*/
struct CosmosTouchTarget {
    static func optimize(_ bounds: CGRect) -> CGRect {
        let recommendedHitSize: CGFloat = 44

        var hitWidthIncrease:CGFloat = recommendedHitSize - bounds.width
        var hitHeightIncrease:CGFloat = recommendedHitSize - bounds.height

        if hitWidthIncrease < 0 { hitWidthIncrease = 0 }
        if hitHeightIncrease < 0 { hitHeightIncrease = 0 }

        let extendedBounds: CGRect = bounds.insetBy(dx: -hitWidthIncrease / 2,
                                                    dy: -hitHeightIncrease / 2)

        return extendedBounds
    }
}
