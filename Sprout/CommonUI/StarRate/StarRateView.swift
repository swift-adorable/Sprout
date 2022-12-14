//
//  StarRatingView.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

public enum StarFillMode: Int {
    case full = 0
    case half = 1
    case precise = 2
}

public enum StarFillImage {
    case full
    case half
    case empty
}

@IBDesignable open class StarRatingView: UIView {
    
    /**

    The currently shown number of stars, usually between 1 and 5. If the value is decimal the stars will be shown according to the Fill Mode setting.

    */
    @IBInspectable open var rating: Double = StarRateDefaultSettings.rating {
        didSet {
            if oldValue != rating {
                update()
            }
        }
    }

    /// Currently shown text. Set it to nil to display just the stars without text.
    @IBInspectable open var text: String? {
        didSet {
            if oldValue != text {
                update()
            }
        }
    }

    /// Star rating settings.
    open var settings: StarRateSettings = .default {
        didSet {
            update()
        }
    }
  
    /// Stores calculated size of the view. It is used as intrinsic content size.
    private var viewSize = CGSize()

    /// Draws the stars when the view comes out of storyboard with default settings
    open override func awakeFromNib() {
        super.awakeFromNib()

        update()
    }

    /**

    Initializes and returns a newly allocated cosmos view object.

    */
    public convenience init(settings: StarRateSettings = .default) {
        self.init(frame: .zero, settings: settings)
    }

    /**

    Initializes and returns a newly allocated cosmos view object with the specified frame rectangle.

    - parameter frame: The frame rectangle for the view.

    */
    override public convenience init(frame: CGRect) {
        self.init(frame: frame, settings: .default)
    }

    public init(frame: CGRect, settings: StarRateSettings) {
        super.init(frame: frame)
        self.settings = settings
        update()
        improvePerformance()
    }

    /// Initializes and returns a newly allocated cosmos view object.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        improvePerformance()
    }
  
    /// Change view settings for faster drawing
    private func improvePerformance() {
        /// Cache the view into a bitmap instead of redrawing the stars each time
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        isOpaque = true
    }

    /**

    Updates the stars and optional text based on current values of `rating` and `text` properties.

    */
    open func update() {

        // Create star layers
        // ------------

        let layers = StarRateLayers.createStarLayers(rating, settings: settings,
                                                     isRightToLeft: RightToLeft.isRightToLeft(self))

        layer.sublayers = layers


        // Update size
        // ------------

        updateSize(layers)

        // Update accesibility
        // ------------

        updateAccessibility()
    }

    /**

    Updates the size to fit all the layers containing stars and text.

    - parameter layers: Array of layers containing stars and the text.

    */
    private func updateSize(_ layers: [CALayer]) {
        viewSize = StarRateSize.calculateSizeToFitLayers(layers)
        invalidateIntrinsicContentSize()

        // Stretch the view to include all stars and the text.
        // Needed when used without Auto Layout to receive touches for all stars.
        frame.size = intrinsicContentSize
    }

    /// Returns the content size to fit all the star and text layers.
    override open var intrinsicContentSize:CGSize {
        return viewSize
    }
  
    /**

    Prepares the Cosmos view for reuse in a table view cell.
    If the cosmos view is used in a table view cell, call this method after the
    cell is dequeued. Alternatively, override UITableViewCell's prepareForReuse method and call
    this method from there.

    */
    open func prepareForReuse() {
        previousRatingForDidTouchCallback = -123.192
    }

    /**

    Makes sure that the right colors are used when the user switches between Light and Dark mode
    while the app is running

    */
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        settings.fullImage = fullImage?.imageAsset?.image(with: traitCollection)
        settings.halfImage = halfImage?.imageAsset?.image(with: traitCollection)
        settings.emptyImage = emptyImage?.imageAsset?.image(with: traitCollection)
    }

    // MARK: - Accessibility

    private func updateAccessibility() {
        StarRateAccessibility.update(self, rating: rating, text: text, settings: settings)
    }

    /// Called by the system in accessibility voice-over mode when the value is incremented by the user.
    open override func accessibilityIncrement() {
        super.accessibilityIncrement()

        rating += StarRateAccessibility.accessibilityIncrement(rating, settings: settings)
        didTouchCosmos?(rating)
        didFinishTouchingCosmos?(rating)
    }

    /// Called by the system in accessibility voice-over mode when the value is decremented by the user.
    open override func accessibilityDecrement() {
        super.accessibilityDecrement()

        rating -= StarRateAccessibility.accessibilityDecrement(rating, settings: settings)
        didTouchCosmos?(rating)
        didFinishTouchingCosmos?(rating)
    }

    // MARK: - Touch recognition

    /// Closure will be called when user touches the cosmos view. The touch rating argument is passed to the closure.
    open var didTouchCosmos: ((Double)->())?

    /// Closure will be called when the user lifts finger from the cosmos view. The touch rating argument is passed to the closure.
    open var didFinishTouchingCosmos: ((Double)->())?

    /// Overriding the function to detect the first touch gesture.
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if settings.passTouchesToSuperview { super.touchesBegan(touches, with: event) }
        guard let location = touchLocationFromBeginningOfRating(touches) else { return }
        onDidTouch(location)
    }

    /// Overriding the function to detect touch move.
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if settings.passTouchesToSuperview { super.touchesMoved(touches, with: event) }
        guard let location = touchLocationFromBeginningOfRating(touches) else { return }
        onDidTouch(location)
    }

    /// Returns the distance of the touch relative to the left edge of the first star
    func touchLocationFromBeginningOfRating(_ touches: Set<UITouch>) -> CGFloat? {
        guard let touch = touches.first else { return nil }
        var location = touch.location(in: self).x

        // In right-to-left languages, the first star will be on the right
        if RightToLeft.isRightToLeft(self) { location = bounds.width - location }

        return location
    }
  
    /// Detecting event when the user lifts their finger.
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if settings.passTouchesToSuperview { super.touchesEnded(touches, with: event) }
        didFinishTouchingCosmos?(rating)
    }

    /// Deciding whether to recognize a gesture.
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if settings.disablePanGestures {
            return !(gestureRecognizer is UIPanGestureRecognizer)
        }
        return true
    }

    /**

    Detecting event when the touches are cancelled (can happen in a scroll view).
    Behave as if user has lifted their finger.

    */
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if settings.passTouchesToSuperview { super.touchesCancelled(touches, with: event) }
        didFinishTouchingCosmos?(rating)
    }

    /**

    Called when the view is touched.

    - parameter locationX: The horizontal location of the touch relative to the width of the stars.

    - parameter starsWidth: The width of the stars excluding the text.

    */
    func onDidTouch(_ locationX: CGFloat) {
        let calculatedTouchRating = StarRateTouch.touchRating(locationX, settings: settings)

        if settings.updateOnTouch {
            rating = calculatedTouchRating
        }

        if calculatedTouchRating == previousRatingForDidTouchCallback {
            // Do not call didTouchCosmos if rating has not changed
            return
        }

        didTouchCosmos?(calculatedTouchRating)
        previousRatingForDidTouchCallback = calculatedTouchRating
    }
  
    private var previousRatingForDidTouchCallback: Double = -123.192

    /// Increase the hitsize of the view if it's less than 44px for easier touching.
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let oprimizedBounds = CosmosTouchTarget.optimize(bounds)
        return oprimizedBounds.contains(point)
    }


    // MARK: - Properties inspectable from the storyboard

    @IBInspectable var totalStars: Int = StarRateDefaultSettings.totalStars {
        didSet {
            settings.totalStars = totalStars
        }
    }

    @IBInspectable var starSize: Double = StarRateDefaultSettings.starSize {
        didSet {
            settings.starSize = starSize
        }
    }

    @IBInspectable var filledColor: UIColor = StarRateDefaultSettings.filledColor {
        didSet {
            settings.filledColor = filledColor
        }
    }
  
    @IBInspectable var emptyColor: UIColor = StarRateDefaultSettings.emptyColor {
        didSet {
            settings.emptyColor = emptyColor
        }
    }

    @IBInspectable var emptyBorderColor: UIColor = StarRateDefaultSettings.emptyBorderColor {
        didSet {
            settings.emptyBorderColor = emptyBorderColor
        }
    }

    @IBInspectable var emptyBorderWidth: Double = StarRateDefaultSettings.emptyBorderWidth {
        didSet {
            settings.emptyBorderWidth = emptyBorderWidth
        }
    }

    @IBInspectable var filledBorderColor: UIColor = StarRateDefaultSettings.filledBorderColor {
        didSet {
            settings.filledBorderColor = filledBorderColor
        }
    }

    @IBInspectable var filledBorderWidth: Double = StarRateDefaultSettings.filledBorderWidth {
        didSet {
            settings.filledBorderWidth = filledBorderWidth
        }
    }
  
    @IBInspectable var starMargin: Double = StarRateDefaultSettings.starMargin {
        didSet {
            settings.starMargin = starMargin
        }
    }

    @IBInspectable var fillMode: Int = StarRateDefaultSettings.fillMode.rawValue {
        didSet {
            settings.fillMode = StarFillMode(rawValue: fillMode) ?? StarRateDefaultSettings.fillMode
        }
    }
  
    @IBInspectable var updateOnTouch: Bool = StarRateDefaultSettings.updateOnTouch {
        didSet {
            settings.updateOnTouch = updateOnTouch
        }
    }

    @IBInspectable var minTouchRating: Double = StarRateDefaultSettings.minTouchRating {
        didSet {
            settings.minTouchRating = minTouchRating
        }
    }

    @IBInspectable var fullImage: UIImage? {
        didSet {
            settings.fullImage = fullImage
        }
    }
    
    @IBInspectable var halfImage: UIImage? {
        didSet {
            settings.halfImage = halfImage
        }
    }
  
    @IBInspectable var emptyImage: UIImage? {
        didSet {
            settings.emptyImage = emptyImage
        }
    }
  
    /// Draw the stars in interface buidler
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        update()
    }
}
