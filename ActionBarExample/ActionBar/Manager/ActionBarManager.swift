//
//  ActionBarManager.swift
//  cewefotowelt
//
//  Created by Naziyok, Tolga on 19.12.19.
//  Copyright © 2019 CEWE. All rights reserved.
//

/// Code clarity typealias
public typealias ButtonIndex = Int

import Foundation
import UIKit

/// Used to create and manage a custom ActionBar
///
/// *Primary Usage*
///
///   1. Create your customized `ActionBarProperties`
///   2. Initialize the `ActionBarManager` with it
///   3. Add the `actionBarView` as subview
///   4. (Optional) If you want to place the view in a `BottomSafeAreaContainer`,
///      add the `bottomSafeAreaContainer` as subview instead.
///   5. Set constraints (for the `bottomSafeAreaContainer`, just call `.autoCreateConstraints()`
///
/// *Alternative Usage*
///
///   1. Initialize an empty `ActionBarManager`
///   2. Add the `actionBarView` as subview
///   3. (Optional) If you want to place the view in a `BottomSafeAreaContainer`,
///      add the `bottomSafeAreaContainer` as subview instead.
///   4. Set constraints (for the `bottomSafeAreaContainer`, just call `.autoCreateConstraints()`
///   5. Add/Set all properties you need, beginning with setCTA`
///
/// ```
///      _______________________
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |                       |
///     |_______________________|
///     |2    |1    |(50% Width)|
///     |  F  |  F  |    CTA    | <- Actionbar in BottomSafeAreaContainer
///     |_____|_____|___________|
///              ^
///              |
///              FeatureButtons are numbered right to left
///
/// ```
///
/// This class offers additional functionality to interact with the `ActionBarView`. The view itself can
/// be used in a view controller as usual, but this acts as a place to write centralized functionality.
/// The alternative meant to be used when not all information are available at creation.
public final class ActionBarManager
{
    // MARK: Public Properties

    /// The main component `ActionBarView` that resulted from the `ActionBarProperties` argument.
    public var actionBarView: ActionBarView

    // MARK: Private Properties

    private var properties: ActionBarProperties

    /// This is the primary init to setup a new `ActionBarView`.
    ///
    /// **Important**: If you don't use `ActionBarProperties` you need to start with `addCTA()`,
    /// otherwise the layout will be wrong.
    ///
    /// - Parameter properties: Predefined properties that define the `ActionBarView`
    public init(properties: ActionBarProperties? = nil)
    {
        self.properties = properties ?? ActionBarProperties()
        actionBarView = ActionBarView(actionBarProperties: self.properties)
    }
}

// MARK: - Public Functions

public extension ActionBarManager
{
    // MARK: Add / Update Functions

    /// Add a specific button with any property. Be sure to add your `cta` type first!
    ///
    /// * Either title OR icon has to be set, but not both
    /// * Important: If both title and icon are `nil` the function will not generate a new button.
    ///
    /// - Parameters:
    ///   - buttonType: The type of button you want to add
    ///   - title: The title of this button
    ///   - icon: The icon of this button
    ///   - subtitle: The subtitle of this button
    ///   - tint: The color of the title, icon and subtitle
    ///   - backgroundColor: The background color of this button
    ///   - action: The action to perform on tap
    /// - Returns: For the button type `.featureButton` returns the corresponding button index
    @discardableResult
    func add(
        buttonType: ActionBarProperties.ButtonType,
        title: String? = nil,
        icon: UIImage? = nil,
        subtitle: String? = nil,
        tint: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        action: @escaping () -> Void
    ) -> ButtonIndex?
    {
        switch buttonType
        {
            case .cta:
                addCTA(
                    title: title,
                    icon: icon,
                    subtitle: subtitle,
                    tint: tint,
                    backgroundColor: backgroundColor,
                    action: action
                )
                return nil
            case .featureButton:
                addFeatureButton(
                    title: title,
                    icon: icon,
                    subtitle: subtitle,
                    tint: tint,
                    backgroundColor: backgroundColor,
                    action: action
                )

                guard let buttons: [ABP.TitleOrIconButton] = properties.featureButtons else { return nil }

                return buttons.count - 1
        }
    }

    /// Update any property of a specified button. Use `buttonIndex` for a `FeatureButton`.
    ///
    /// * No value means the original value will be kept.
    /// * You can't change from title to icon or vice versa.
    /// * If both, a title and icon is given, the update will return without any change
    ///
    /// - Parameters:
    ///   - buttonType: The type of button you want to update
    ///   - title: The new title
    ///   - icon: The new icon
    ///   - subtitle: The new subtitle
    ///   - tint: The new tint color for title and subtitle
    ///   - action: A new action to perform on click
    ///   - backgroundColor: A new background color
    ///   - buttonIndex: Determines the exact `featureButton` to update. No effect for type `cta`.
    func update(
        buttonType: ActionBarProperties.ButtonType,
        title: String? = nil,
        icon: UIImage? = nil,
        subtitle: String? = nil,
        tint: UIColor? = nil,
        action: (() -> Void)? = nil,
        backgroundColor: UIColor? = nil,
        buttonIndex: ButtonIndex? = nil
    )
    {
        // Make sure that not title and icon are both set
        guard (title == nil ) || (icon == nil) else { return }

        switch buttonType
        {
            case .cta:
                updateCTA(
                    title: title,
                    icon: icon,
                    subtitle: subtitle,
                    tint: tint,
                    action: action,
                    backgroundColor: backgroundColor
                )
            case .featureButton:
                guard let buttonIndex = buttonIndex else { return }

                updateFeatureButton(
                    title: title,
                    icon: icon,
                    subtitle: subtitle,
                    tintColor: tint,
                    action: action,
                    backgroundColor: backgroundColor,
                    buttonIndex: buttonIndex
                )
        }
    }

    // MARK: - Hide Functions

    /// Hides a specific button. Use `buttonIndex` for a `FeatureButton`.
    /// - Parameters:
    ///   - buttonType: The type of button you want to hide
    ///   - buttonIndex: Determines the exact `featureButton` to hide. No effect for type `cta`.
    func hide(buttonType: ActionBarProperties.ButtonType, buttonIndex: ButtonIndex? = nil)
    {
        switch buttonType
        {
            case .cta: actionBarView.hideCTA(true)
            case .featureButton:
                guard let buttonIndex = buttonIndex else { return }
                actionBarView.hideFeatureButton(true, buttonIndex: buttonIndex)
        }
    }

    /// Shows a specific button. Use `buttonIndex` for a `FeatureButton`.
    /// - Parameters:
    ///   - buttonType: The type of button you want to show
    ///   - buttonIndex: Determines the exact `featureButton` to show. No effect for type `cta`.
    func show(buttonType: ActionBarProperties.ButtonType, buttonIndex: ButtonIndex? = nil)
    {
        switch buttonType
        {
            case .cta: actionBarView.hideCTA(false)
            case .featureButton:
                guard let buttonIndex = buttonIndex else { return }
                actionBarView.hideFeatureButton(false, buttonIndex: buttonIndex)
        }
    }
}

// MARK: - Private Functions

private extension ActionBarManager
{
    func addCTA(
        title: String?,
        icon: UIImage?,
        subtitle: String? = nil,
        tint: UIColor?,
        backgroundColor: UIColor?,
        action: @escaping () -> Void
    )
    {
        guard
            properties.callToActionBarButton == nil,
            let titleOrIcon = ABP.TitleOrIcon(
                title: title,
                icon: icon,
                tint: tint ?? .white,
                font: ABP.Title.defaultCTATitleFont
            )
        else { return }

        let ctaButton = ABP.TitleOrIconButton(
            titleOrIcon: titleOrIcon,
            subtitle: ABP.Title(
                text: subtitle,
                tint: tint ?? .white,
                font: ABP.Title.defaultCTASubTitleFont
            ),
            backgroundColor: backgroundColor ?? ActionBarProperties.defaultCTAColor,
            action: action
        )

        synchronizeCTA(with: ctaButton)
    }

    func addFeatureButton(
        title: String?,
        icon: UIImage?,
        subtitle: String? = nil,
        tint: UIColor?,
        backgroundColor: UIColor?,
        action: (() -> Void)?
    )
    {
        guard let titleOrIcon = ABP.TitleOrIcon(
            title: title,
            icon: icon,
            tint: tint ?? ABP.defaultTintColor,
            font: ABP.Title.defaultTitleFont
        )
        else { return }

        let button = ABP.TitleOrIconButton(
            titleOrIcon: titleOrIcon,
            subtitle: ABP.Title(
                text: subtitle,
                tint: tint ?? ABP.defaultTintColor,
                font: ABP.Title.defaultSubTitleFont
            ),
            backgroundColor: backgroundColor ?? .clear,
            action: action
        )

        synchronizeFeatureButton(with: button)
    }

    func synchronizeCTA(with ctaProperties: ActionBarProperties.TitleOrIconButton)
    {
        if properties.callToActionBarButton == nil
        {
            actionBarView.setupCTAButton(ctaProperties, width: properties.ctaWidthCGFloat)
        }
        else
        {
            actionBarView.updateCTAButton(ctaProperties)
        }
        properties.callToActionBarButton = ctaProperties
    }

    /// If feature buttons are present, append the new one to the list.
    /// Otherwise, the new button is the whole list.
    /// Persist the properties and the view after.
    func synchronizeFeatureButton(with buttonProperties: ActionBarProperties.TitleOrIconButton)
    {
        if var buttons: [ABP.TitleOrIconButton] = properties.featureButtons
        {
            buttons.append(buttonProperties)
            properties.featureButtons = buttons
            actionBarView.setupFeatureButtons(buttons, width: properties.featureButtonWidthPercentage)
        }
        else
        {
            properties.featureButtons = [buttonProperties]
            actionBarView.setupFeatureButtons([buttonProperties], width: properties.featureButtonWidthPercentage)
        }
    }

    func synchronizeFeatureButtonUpdate(_ buttonProperties: ABP.TitleOrIconButton, _ buttonIndex: Int)
    {
        guard var buttons: [ABP.TitleOrIconButton] = properties.featureButtons else { return }

        buttons[buttonIndex] = buttonProperties
        properties.featureButtons = buttons
        actionBarView.updateFeatureButton(buttonProperties, buttonIndex: buttonIndex)
    }

    func updateCTA(
        title: String?,
        icon: UIImage?,
        subtitle: String?,
        tint: UIColor?,
        action: (() -> Void)? = nil,
        backgroundColor: UIColor?
    )
    {
        guard var ctaProperties: ABP.TitleOrIconButton = properties.callToActionBarButton else { return }

        if let titleOrIcon = ABP.TitleOrIcon(
            title: title,
            icon: icon,
            tint: ctaProperties.titleOrIcon.tint,
            font: ABP.Title.defaultCTATitleFont
        )
        {
            ctaProperties.titleOrIcon = titleOrIcon
        }

        if let subtitle = subtitle
        {
            ctaProperties.subtitle = ABP.Title(
                text: subtitle,
                tint: ctaProperties.subtitle?.tint ?? .white,
                font: ABP.Title.defaultCTASubTitleFont
            )

            if subtitle == "" { ctaProperties.subtitle = nil }
        }

        if let tint: UIColor = tint
        {
            ctaProperties.titleOrIcon.updateTintColor(tint)
            ctaProperties.subtitle?.tint = tint
        }

        if let action = action
        {
            ctaProperties.action = action
        }

        if let backgroundColor: UIColor = backgroundColor { ctaProperties.backgroundColor = backgroundColor }

        synchronizeCTA(with: ctaProperties)
    }

    func updateFeatureButton(
        title: String?,
        icon: UIImage?,
        subtitle: String?,
        tintColor: UIColor? = nil,
        action: (() -> Void)? = nil,
        backgroundColor: UIColor? = nil,
        buttonIndex: Int
    )
    {
        guard
            let buttons: [ABP.TitleOrIconButton] = properties.featureButtons,
            buttons.count > buttonIndex
        else { return }

        var buttonProperties: ABP.TitleOrIconButton = buttons[buttonIndex]

        if let titleOrIcon = ABP.TitleOrIcon(
            title: title,
            icon: icon,
            tint: buttonProperties.titleOrIcon.tint,
            font: ABP.Title.defaultTitleFont
        )
        {
            buttonProperties.titleOrIcon = titleOrIcon
        }

        if let subtitle = subtitle
        {
            buttonProperties.subtitle = ABP.Title(
                text: subtitle,
                tint: buttonProperties.subtitle?.tint ?? ABP.defaultTintColor,
                font: ABP.Title.defaultSubTitleFont
            )
            if subtitle == "" { buttonProperties.subtitle = nil }
        }

        if let tintColor = tintColor
        {
            buttonProperties.titleOrIcon.updateTintColor(tintColor)
            buttonProperties.subtitle?.tint = tintColor
        }

        if let action = action
        {
            buttonProperties.action = action
        }

        if let backgroundColor: UIColor = backgroundColor { buttonProperties.backgroundColor = backgroundColor }

        synchronizeFeatureButtonUpdate(buttonProperties, buttonIndex)
    }
}
