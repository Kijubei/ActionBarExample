//
//  ActionBarView.swift
//  targets
//
//  Created by Naziyok, Tolga on 19.12.19.
//  Copyright © 2019 CEWE. All rights reserved.
//

import Foundation
import UIKit

/// This is the View, that contains all buttons and labels that make up the action bar.
/// This view is initialized by the `ActionBarManager` and should not be used directly
/// - Tag: ActionBarView
public final class ActionBarView: UIView
{
    // MARK: Private Properties

    /// The CTA button, getter only
    private(set) public var ctaButton: ActionBarButtonView?

    /// The feature buttons, getter only
    private(set) public var featureButtons: [ActionBarButtonView] = []

    /// The info text button, getter only
    private(set) public var infoTextButton: ActionBarButtonView?

    /// This extra background is needed, because the backgroundColor of `self` is cleared by
    /// the `BottomSafeAreaContainer`.
    private let background: UIView = UIView()

    private let pHorizontalLine: UIView = UIView.newAutoLayout()

    // MARK: Public Properties

    public override var intrinsicContentSize: CGSize
    {
        return CGSize(width: UIView.noIntrinsicMetric, height: 56)
    }

    init(actionBarProperties: ActionBarProperties)
    {
        super.init(frame: .zero)
        setup(actionBarProperties)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    public override func addSubview(_ view: UIView)
    {
        /// Force `pHorizontalLine` to be the top most view
        super.insertSubview(view, belowSubview: pHorizontalLine)
    }
}

// MARK: - Private functions

private extension ActionBarView
{
    func setup(_ actionBarProperties: ActionBarProperties)
    {
        setupBackground(actionBarProperties)
        setupHorizontalLine()

        if let ctaButtonProperties: ABP.TitleOrIconButton = actionBarProperties.callToActionBarButton
        {
            setupCTAButton(ctaButtonProperties, width: actionBarProperties.ctaWidthCGFloat)
        }
        if let buttonPropertiesList: [ABP.TitleOrIconButton] = actionBarProperties.featureButtons
        {
            setupFeatureButtons(
                buttonPropertiesList,
                width: actionBarProperties.featureButtonWidthPercentage
            )
        }
    }

    /// The default background color is whiteGrey from the `StyleGuideColor`
    func setupBackground(_ actionBarProperties: ActionBarProperties)
    {
        background.backgroundColor = actionBarProperties.backgroundColor
        addSubview(background)
        background.autoPinEdgesToSuperviewEdges()
    }

    /// Should separate the bar from other views above the bar - UX TL.
    /// Must be the topmost view - see `addSubview` override
    func setupHorizontalLine()
    {
        pHorizontalLine.backgroundColor = UIColor.horizontalLineColor
        addSubview(pHorizontalLine)

        pHorizontalLine.autoPinEdge(toSuperviewEdge: .left)
        pHorizontalLine.autoPinEdge(toSuperviewEdge: .right)
        pHorizontalLine.autoPinEdge(toSuperviewEdge: .top)
        pHorizontalLine.autoSetDimension(.height, toSize: CGFloat.horizontalLineHeight)
    }

    func setupFeatureButton(
        _ properties: ActionBarProperties.TitleOrIconButton,
        _ previousButton: UIView?,
        _ featureButtonWidth: CGFloat
    ) -> ActionBarButtonView
    {
        let button = ActionBarButtonView(properties: properties)
        addSubview(button)
        setFeatureButtonConstraints(
            for: button,
            widthMultiplier: featureButtonWidth,
            previousButton: previousButton
        )
        return button
    }

    func removeFeatureButtons()
    {
        for view in featureButtons
        {
            view.removeFromSuperview()
        }
        featureButtons = []
    }

    // MARK: - Button Constraint Functions

    /// The CTA-button has a fixed percentage based width and is always positioned against the right edge
    /// - Parameters:
    ///   - button: The button to set constraints for
    ///   - widthMultiplier: Percentage based multiplier: e.g.: a value of 0.5 would take half the width of the bar
    func setCTAButtonConstraints(for button: ActionBarButtonView, widthMultiplier: CGFloat)
    {
        button.autoPinEdge(toSuperviewEdge: .right)
        button.autoPinEdge(toSuperviewEdge: .top)
        button.autoPinEdge(toSuperviewEdge: .bottom)
        button.autoMatch(.width, to: .width, of: self, withMultiplier: widthMultiplier)
    }

    /// The feature-buttons always align right and are positioned at the left of the previous button
    /// - Parameters:
    ///   - button: The button to set constraints for
    ///   - widthMultiplier: Percentage based multiplier: e.g.: a value of 0.5 would take half the width of the bar
    ///   - previousButton: The previous button, to the right of this button
    func setFeatureButtonConstraints(for button: ActionBarButtonView, widthMultiplier: CGFloat, previousButton: UIView?)
    {
        if let previousButton = previousButton
        {
            button.autoPinEdge(.right, to: .left, of: previousButton)
        }
        else
        {
            button.autoPinEdge(toSuperviewEdge: .right)
        }
        button.autoPinEdge(toSuperviewEdge: .top)
        button.autoPinEdge(toSuperviewEdge: .bottom)
        button.autoMatch(.width, to: .width, of: self, withMultiplier: widthMultiplier)
    }

    /// The Info-I-button is always aligned to the left edge of the view, with a little extra space
    /// - Parameter button: The button to set constraints for
    func setInfoIIconButtonConstraints(for button: ActionBarButtonView)
    {
        button.autoPinEdge(toSuperviewEdge: .left, withInset: CGFloat.horizontalOffset)
        button.autoPinEdge(toSuperviewEdge: .top)
        button.autoPinEdge(toSuperviewEdge: .bottom)
        button.autoSetDimension(.width, toSize: .infoIIconWidth)
    }

    /// The infoI-text area is always pinned to the left infoI-icon area and pinned to the CTA button, if it exists.
    /// - Parameters:
    ///   - button: The button to set constraints for
    ///   - iconButton: The infoI-icon button
    ///   - ctaButton: The optional CTA button
    func setInfoITextButtonConstraints(for button: ActionBarButtonView, iconButton: UIView, ctaButton: UIView?)
    {
        if let ctaButton = ctaButton
        {
            button.autoPinEdge(.right, to: .left, of: ctaButton)
        }
        else
        {
            button.autoPinEdge(toSuperviewEdge: .right)
        }
        button.autoPinEdge(.left, to: .right, of: iconButton)
        button.autoPinEdge(toSuperviewEdge: .top)
        button.autoPinEdge(toSuperviewEdge: .bottom)
    }
}

// MARK: - Internal functions

extension ActionBarView
{
    // MARK: - CTA-Button

    /// Don't use directly. Use `addCTA` from `ActionBarManager` instead.
    ///
    /// The CTA-button is a `ActionBarButton`, that takes priority in width before the feature-buttons or info-I
    ///
    /// - Parameters:
    ///   - buttonProperties: The properties to build the view with
    ///   - ctaWidth: The width for the CTA-button as percentage
    func setupCTAButton(_ buttonProperties: ActionBarProperties.TitleOrIconButton, width ctaWidth: CGFloat)
    {
        let button: ActionBarButtonView = ActionBarButtonView(properties: buttonProperties)
        addSubview(button)
        setCTAButtonConstraints(for: button, widthMultiplier: ctaWidth)

        ctaButton = button
    }

    /// Don't use directly. Use `updateCTA` from `ActionBarManager` instead.
    ///
    /// - Parameter buttonProperties: The updated properties
    func updateCTAButton(_ buttonProperties: ActionBarProperties.TitleOrIconButton)
    {
        ctaButton?.update(buttonProperties)
    }

    /// Hides or unhides the CTA Button
    /// - Parameter willHide: If true, the button will hide
    func hideCTA(_ willHide: Bool)
    {
        // TODO: fadeout
        if willHide
        {
//            ctaButton?.fadeOut()
        }
        else
        {
//            ctaButton?.fadeIn()
        }
    }

    // MARK: - FeatureButtons

    /// Don't use directly. Use `addFeatureButton` from `ActionBarManager` instead.
    ///
    /// Several `BarButtons` held in the remaining space, after the CTA-Button took its space.
    /// The remaining space is shared equally among the feature buttons.
    ///
    /// - Parameters:
    ///     - buttons: The properties to build the view
    ///     - ctaWidth: The width for the CTA-button as percentage
    func setupFeatureButtons(_ buttons: [ActionBarProperties.TitleOrIconButton], width featureButtonWidth: CGFloat)
    {
        removeFeatureButtons()

        // at the beginning, set previousButton to ctaButton, if one exists
        var previousButton: UIView?
        if ctaButton != nil
        {
            previousButton = ctaButton
        }

        for buttonProperties in buttons
        {
            let button = setupFeatureButton(buttonProperties, previousButton, featureButtonWidth)
            previousButton = button

            featureButtons.append(button)
        }
    }

    /// Don't use directly. Use `updateFeatureButton` from `ActionBarManager` instead.
    ///
    /// - Parameters:
    ///   - buttonProperties: The properties to build the view
    ///   - buttonIndex: The index of the feature button to update
    func updateFeatureButton(_ buttonProperties: ActionBarProperties.TitleOrIconButton, buttonIndex: Int)
    {
        guard featureButtons.count > buttonIndex else
        {
            print("[ActionBar]: prevented null-pointer exception while updating feature buttons!")
            return
        }

        featureButtons[buttonIndex].update(buttonProperties)
    }

    /// Hides or unhides the FeatureButton
    /// - Parameter
    ///   - willHide: If true, the button will hide
    ///   - buttonIndex: The index of the feature button to hide
    func hideFeatureButton(_ willHide: Bool, buttonIndex: Int)
    {
        guard featureButtons.count > buttonIndex else
        {
            print("[ActionBar]: prevented null-pointer exception while hiding feature buttons!")
            return
        }

        // TODO: fade
        if willHide
        {
//            featureButtons[buttonIndex].fadeOut()
        }
        else
        {
//            featureButtons[buttonIndex].fadeIn()
        }
    }
}

private extension CGFloat
{
    static let horizontalOffset = UIDevice.current.userInterfaceIdiom == .pad ? 20.0 : 6.0
    static let infoIIconWidth = CGFloat(30)
    static let horizontalLineHeight: CGFloat = 0.5
}

private extension UIColor
{
    static let horizontalLineColor: UIColor = UIColor.black.withAlphaComponent(0.1)
}
