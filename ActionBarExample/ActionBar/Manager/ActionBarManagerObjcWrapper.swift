//
//  ActionBarManagerObjcWrapper.swift
//  targets
//
//  Created by Naziyok, Tolga on 03.04.20.
//  Copyright © 2020 CEWE. All rights reserved.
//

import Foundation
import UIKit

@objc
public final class ActionBarManagerObjcWrapper: NSObject
{
    private let pActionbarManager: ActionBarManager

    /// Creates an empty `ActionBarManager`. Use set functions to fill it with content.
    @objc
    public override init()
    {
        pActionbarManager = ActionBarManager()
    }

    /// The main component `ActionBarView` that resulted from the `ActionBarProperties` argument.
    @objc
    public func actionBarView() -> UIView
    {
        return pActionbarManager.actionBarView
    }

    @objc
    public func ctaView() -> UIView?
    {
        return pActionbarManager.actionBarView.ctaButton
    }

    @objc
    public func featureButtonViewList() -> [UIView]
    {
        return pActionbarManager.actionBarView.featureButtons
    }

    @objc
    public func infoTextView() -> UIView?
    {
        return pActionbarManager.actionBarView.infoTextButton
    }

    /// Adds a CTA with a title to this `ActionBarManager`, if none exists already.
    /// **Important** If you have other elements in your actionbar, call this always first!
    /// - Parameters:
    ///   - title: The title of the CTA Button
    ///   - subtitle: The subtitle of the CTA Button
    ///   - action: The performed action on click
    @objc
    public func addCTA(
        title: String,
        subtitle: String? = nil,
        action: @escaping () -> Void
    )
    {
        pActionbarManager.add(buttonType: .cta, title: title, subtitle: subtitle, action: action)
    }

    /// Adds a CTA with an icon to this `ActionBarManager`, if none exists already.
    /// **Important** If you have other elements in your actionbar, call this always first!
    /// - Parameters:
    ///   - icon: The icon of the CTA Button
    ///   - subtitle: The subtitle of the CTA Button
    ///   - action: The performed action on click
    @objc
    public func addCTA(
        icon: UIImage,
        subtitle: String? = nil,
        action: @escaping () -> Void
    )
    {
        pActionbarManager.add(buttonType: .cta, icon: icon, subtitle: subtitle, action: action)
    }

    /// Adds a FeatureButton with an icon to this `ActionBarManager`
    ///
    /// - Parameters:
    ///   - icon: the icon for the button
    ///   - action: The performed action on click
    ///   - tintColor: the tint color
    /// - Returns: The button index
    @objc
    @discardableResult
    public func addFeatureButton(
        icon: UIImage,
        tintColor: UIColor,
        action: @escaping () -> Void
    ) -> ButtonIndex
    {
        pActionbarManager.add(buttonType: .featureButton, icon: icon, tint: tintColor, action: action) ?? -1
    }

    /// Adds a FeatureButton with a title to this `ActionBarManager`
    ///
    /// - Parameters:
    ///   - title: the title for the button
    ///   - action: The performed action on click
    ///   - tintColor: the tint color
    /// - Returns: The button index
    @objc
    @discardableResult
    public func addFeatureButton(
        title: String,
        tintColor: UIColor,
        action: @escaping () -> Void
    ) -> ButtonIndex
    {
        pActionbarManager.add(buttonType: .featureButton, title: title, tint: tintColor, action: action) ?? -1
    }

    /// Use to update the tint color of a feature button
    ///
    /// - Parameters:
    ///   - tintColor The new tint color
    ///   - buttonIndex: The feature button index
    @objc
    public func updateFeatureButton(tintColor: UIColor, buttonIndex: ButtonIndex)
    {
        pActionbarManager.update(buttonType: .featureButton, tint: tintColor, buttonIndex: buttonIndex)
    }

    /// Use to update the text of a feature button
    ///
    /// - Parameters:
    ///   - title The new title
    ///   - buttonIndex: The feature button index
    @objc
    public func updateFeatureButton(title: String, buttonIndex: ButtonIndex)
    {
        pActionbarManager.update(buttonType: .featureButton, title: title, buttonIndex: buttonIndex)
    }

}
