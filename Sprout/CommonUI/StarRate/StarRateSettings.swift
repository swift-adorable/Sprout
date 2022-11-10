//
//  StarRateSettings.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
//MARK: - Star Rate Settings
public struct StarRateSettings {

    /// Returns default set of settings for CosmosView
    public static var `default`: StarRateSettings {
        return StarRateSettings()
    }

    public init() {}

    // MARK: - Star settings
    // -----------------------------

    /// Border color of an empty star.
    public var emptyBorderColor = StarRateDefaultSettings.emptyBorderColor

    /// Width of the border for empty star.
    public var emptyBorderWidth: Double = StarRateDefaultSettings.emptyBorderWidth

    /// Border color of a filled star.
    public var filledBorderColor = StarRateDefaultSettings.filledBorderColor

    /// Width of the border for a filled star.
    public var filledBorderWidth: Double = StarRateDefaultSettings.filledBorderWidth

    /// Background color of an empty star.
    public var emptyColor = StarRateDefaultSettings.emptyColor

    /// Background color of a filled star.
    public var filledColor = StarRateDefaultSettings.filledColor

    /**

    Defines how the star is filled when the rating value is not a whole integer. It can either show full stars, half stars or stars partially filled according to the rating value.

    */
    public var fillMode = StarRateDefaultSettings.fillMode

    /// Distance between stars.
    public var starMargin: Double = StarRateDefaultSettings.starMargin

    /**

    Array of points for drawing the star with size of 100 by 100 pixels. Supply your points if you need to draw a different shape.

    */
    public var starPoints: [CGPoint] = StarRateDefaultSettings.starPoints

    /// Size of a single star.
    public var starSize: Double = StarRateDefaultSettings.starSize

    /// The maximum number of stars to be shown.
    public var totalStars = StarRateDefaultSettings.totalStars
  
    // MARK: - Star image settings
    // -----------------------------

    /**

    Image used for the filled portion of the star. By default the star is drawn from the array of points unless an image is supplied.

    */
    public var fullImage: UIImage? = nil

    /**

    Image used for the half filled portion of the star. By default the star is drawn from the array of points unless an image is supplied.

    */
    public var halfImage: UIImage? = nil

    /**

    Image used for the empty portion of the star. By default the star is drawn from the array of points unless an image is supplied.

    */
    public var emptyImage: UIImage? = nil
    
    // MARK: - Touch settings
    // -----------------------------

    /// The lowest rating that user can set by touching the stars.
    public var minTouchRating: Double = StarRateDefaultSettings.minTouchRating

    /// Set to `false` if you don't want to pass touches to superview (can be useful in a table view).
    public var passTouchesToSuperview = StarRateDefaultSettings.passTouchesToSuperview

    /// When `true` the star fill level is updated when user touches the cosmos view. When `false` the Cosmos view only shows the rating and does not act as the input control.
    public var updateOnTouch = StarRateDefaultSettings.updateOnTouch

    /// Set to `true` if you want to ignore pan gestures (can be useful when presented modally with a `presentationStyle` of `pageSheet` to avoid competing with the dismiss gesture)
    public var disablePanGestures = StarRateDefaultSettings.disablePanGestures
}


//MARK: - Star Rate Default Settings
struct StarRateDefaultSettings {
    init() {}

    static let defaultColor = UIColor(red: 1, green: 149/255, blue: 0, alpha: 1)


    // MARK: - Star settings
    // -----------------------------

    /// Border color of an empty star.
    static let emptyBorderColor = defaultColor

    /// Width of the border for the empty star.
    static let emptyBorderWidth: Double = 1 / Double(UIScreen.main.scale)

    /// Border color of a filled star.
    static let filledBorderColor = defaultColor

    /// Width of the border for a filled star.
    static let filledBorderWidth: Double = 1 / Double(UIScreen.main.scale)

    /// Background color of an empty star.
    static let emptyColor = UIColor.clear

    /// Background color of a filled star.
    static let filledColor = defaultColor

    /**

    Defines how the star is filled when the rating value is not an integer value. It can either show full stars, half stars or stars partially filled according to the rating value.

    */
    static let fillMode = StarFillMode.full

    /// Rating value that is shown in the storyboard by default.
    static let rating: Double = 2.718281828

    /// Distance between stars.
    static let starMargin: Double = 5

    /**

    Array of points for drawing the star with size of 100 by 100 pixels. Supply your points if you need to draw a different shape.

    */
    static let starPoints: [CGPoint] = [
    CGPoint(x: 49.5,  y: 0.0),
    CGPoint(x: 60.5,  y: 35.0),
    CGPoint(x: 99.0, y: 35.0),
    CGPoint(x: 67.5,  y: 58.0),
    CGPoint(x: 78.5,  y: 92.0),
    CGPoint(x: 49.5,    y: 71.0),
    CGPoint(x: 20.5,  y: 92.0),
    CGPoint(x: 31.5,  y: 58.0),
    CGPoint(x: 0.0,   y: 35.0),
    CGPoint(x: 38.5,  y: 35.0)
    ]

    /// Size of a single star.
    static var starSize: Double = 20

    /// The total number of stars to be shown.
    static let totalStars = 5

    // MARK: - Touch settings
    // -----------------------------

    /// The lowest rating that user can set by touching the stars.
    static let minTouchRating: Double = 0.5

    /// Set to `false` if you don't want to pass touches to superview (can be useful in a table view).
    static let passTouchesToSuperview = true

    /// When `true` the star fill level is updated when user touches the view. When `false` the Cosmos view only shows the rating and does not act as the input control.
    static let updateOnTouch = true

    /// Set to `true` if you want to ignore pan gestures (can be useful when presented modally with a `presentationStyle` of `pageSheet` to avoid competing with the dismiss gesture)
    static let disablePanGestures = false
}
