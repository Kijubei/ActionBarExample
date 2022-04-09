//
//  ActionBarProperties.swift
//  cewefotowelt
//
//  Created by Naziyok, Tolga on 18.12.19.
//  Copyright © 2019 CEWE. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

// Shorthand
typealias ABP = ActionBarProperties

/// These are the properties to initialize the `ActionBarManager` with.
///
/// ```
///                                       ctaWidth
///      backgroundColor                     |
///       |                                  v
///  -----------------------------------------------------+
///  |    |                                  |            |
///  |    v      [FeatureButton]             |  CTAButton |
///  |                                       |            |
///  -----------------------------------------------------+
///
///
/// ```
///
/// This is archived by giving only access to initializers that have one or the other.
public struct ActionBarProperties
{
    // MARK: Public Properties

    /// The default CTA Color
    ///
    /// Can not be private(set) yet, needs the correct color from TCColor injected at runtime.
    public static var defaultCTAColor: UIColor = .red

    /// The default button color
    private(set) public static var defaultButtonColor: UIColor = .white

    /// The default tint color e.g. for `title` or `icon`
    private(set) public static var defaultTintColor: UIColor = .systemBlue

    /// The optional CTA-Button properties
    public var callToActionBarButton: TitleOrIconButton?

    /// Defines what type feature buttons will be shown
    public var featureButtons: [TitleOrIconButton]?

    /// The standard color for the background is white.
    public var backgroundColor: UIColor = .white

    /// This has type CGFloat because it is needed to build the view, later.
    public enum WidthPercentFormat: CGFloat
    {
        case twenty = 0.20
        case twentyfive = 0.25
        case thirty = 0.30
        case fifty = 0.50
    }

    // MARK: Private Properties

    /// The width format for the CTA button in percentage. 50% is standard. Private to ensure use of computed properties.
    private var ctaWidth: WidthPercentFormat = .fifty

    /// The default init is private, because the user is not allowed to initialize properties with
    /// `FeatureButton`s.
    private init(
        callToActionBarButton: TitleOrIconButton? = nil,
        ctaWidth: WidthPercentFormat = .fifty,
        featureButtons: [TitleOrIconButton]?,
        backgroundColor: UIColor = ActionBarProperties.defaultButtonColor
    )
    {
        self.callToActionBarButton = callToActionBarButton
        self.ctaWidth = ctaWidth
        self.featureButtons = featureButtons
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Computed properties

public extension ActionBarProperties
{
    /// Returns the width value (in percentage) for the CTA button as CGFloat while considering if the device is a tablet or not
    ///
    /// ```
    /// Phone -> Tablet
    /// 50% -> 17%
    /// 30% -> 17%
    /// 25% -> 17%
    /// 20% -> 17%
    ///
    /// ```
    ///
    var ctaWidthCGFloat: CGFloat
    {
        if UIDevice.current.userInterfaceIdiom != .pad
        {
            return ctaWidth.rawValue
        }
        else
        {
            return 0.17
        }
    }

    /// The  remaining space (in percentage as number from 0-1) is shared between all feature buttons, so they don't need a width of their own.
    /// Gives the correct width (1), when no `CTAButton` is used.
    var remainingWidth: CGFloat
    {
        let remainingWidth: CGFloat = 1
        if callToActionBarButton != nil
        {
            return remainingWidth - ctaWidthCGFloat
        }
        return remainingWidth
    }

    /// Return the width in % of a feature button. If no feature button is present, the remaining width is returned.
    ///
    /// ```
    ///  -----------------------------------------------------+
    ///  |                                       |            |
    ///  | <--shared between feature buttons --> |  CTAButton |
    ///  |                                       |            |
    ///  -----------------------------------------------------+
    /// ```
    /// The space is shared between feature buttons, so only one button would take all the remaining space.
    /// For an iPad the feature button width is defined as a fix 20%, always added to the right side.
    var featureButtonWidthPercentage: CGFloat
    {
        guard
            let featureButtons: [TitleOrIconButton] = featureButtons
        else { return remainingWidth }

        let buttonCount: Int = featureButtons.count

        if UIDevice.current.userInterfaceIdiom != .pad
        {
            return remainingWidth / CGFloat(buttonCount)
        }
        else
        {
            return 0.17
        }
    }
}

// MARK: - Sub-Structs

public extension ActionBarProperties
{
    /// Can have only a `Title` *or* an `Icon`, not both.
    struct TitleOrIconButton
    {
        public var titleOrIcon: TitleOrIcon
        public var subtitle: Title?
        public var backgroundColor: UIColor = .clear
        public var action: (() -> Void)?
    }

    struct CallToActionButton
    {
        var button: TitleOrIconButton
    }

    /// Properties used to represent a title
    struct Title
    {
        /// Text of the title
        var text: String

        /// Color in which the title is displayed, default is interactiveblue
        var tint: UIColor = ActionBarProperties.defaultTintColor

        /// Defaults to center, unless this is true
        var alignment: NSTextAlignment = .center

        /// The font for the title
        var font: UIFont
    }

    /// Properties used to represent an icon
    struct Icon
    {
        /// The image that represents this icon
        var image: UIImage

        /// Color in which the icon is displayed, default is interactiveblue
        var tint: UIColor = ActionBarProperties.defaultTintColor
    }

    /// An enum that represents *either* a `Title` *or* an `Icon`
    enum TitleOrIcon
    {
        case title(Title)
        case icon(Icon)

        /// Returns the tint value, regardless if this is a `Title` or `Icon` struct.
        var tint: UIColor
        {
            switch self
            {
                case let .title(title): return title.tint
                case let .icon(icon): return icon.tint
            }
        }

        /// Updates the tint color
        ///
        /// - Parameter color: the new tint color
        mutating func updateTintColor(_ color: UIColor)
        {
            switch self
            {
                case let .title(title):
                    let newTitle: Title = Title(
                        text: title.text,
                        tint: color,
                        alignment: title.alignment,
                        font: title.font
                    )

                    self = .title(newTitle)

                case let .icon(icon):
                    let newIcon: Icon = Icon(image: icon.image, tint: color)
                    self = .icon(newIcon)
            }
        }
    }

    /// The type of a button used in the `ActionBarManager`.
    ///
    /// Note: This is used for the public interface only. Not used in the `ActionBarProperties`
    enum ButtonType
    {
        /// A call to action button is defined by its background color (app specific) and that is always on the right edge
        case cta
        /// The regular feature button with either an icon or a title
        case featureButton
    }
}

// MARK: - Initializer: Full Properties

public extension ActionBarProperties
{
    /// An empty ActionBar. Further elements can be added through the `ActionBarManager`
    internal init()
    {
        self.init(
            callToActionBarButton: nil,
            ctaWidth: .fifty,
            featureButtons: nil,
            backgroundColor: ActionBarProperties.defaultButtonColor
        )
    }

    /// ActionBar with just a CTAButton
    /// - Parameter callToActionBarButton: The `CTAButton` for the `ActionBarView`
    init(callToActionBarButton: CallToActionButton?)
    {
        self.init(
            callToActionBarButton: callToActionBarButton?.button,
            ctaWidth: .fifty,
            featureButtons: nil
        )
    }

    /// ActionBar with just a CTAButton
    /// - Parameters:
    ///   - ctaButtonTitle: The title of the `CTAButton`
    ///   - ctaButtonAction: The action of the `CTAButton`
    init(ctaButtonTitle: String, ctaButtonAction: @escaping () -> Void)
    {
        self.init(
            callToActionBarButton: ABP.TitleOrIconButton(
                title: ctaButtonTitle,
                tint: UIColor.white,
                backgroundColor: ActionBarProperties.defaultCTAColor,
                action: ctaButtonAction
            ),
            ctaWidth: .fifty,
            featureButtons: nil
        )
    }

    /// ActionBar with just a CTAButton, that has adjustable width
    /// - Parameters:
    ///   - callToActionBarButton: The `CTAButton` for the `ActionBarView`
    ///   - ctaWidthPercentage: How much percent the `CTAButton`should take
    init(callToActionBarButton: CallToActionButton?, ctaWidthPercentage: WidthPercentFormat)
    {
        self.init(
            callToActionBarButton: callToActionBarButton?.button,
            ctaWidth: ctaWidthPercentage,
            featureButtons: nil
        )
    }

    /// ActionBar with just `FeatureButton`s
    /// - Parameter buttons: The `[FeatureButton]`s that will be displayed
    init(buttons: [TitleOrIconButton])
    {
        self.init(
            callToActionBarButton: nil,
            ctaWidth: .fifty,
            featureButtons: buttons
        )
    }

    /// ActionBar with optional `CTAButton` and `FeatureButtons`
    /// - Parameters:
    ///   - callToActionBarButton: The optional `CTAButton` that will be displayed
    ///   - ctaWidthPercentage: How much percent the `CTAButton`should take
    ///   - buttons: The `[FeatureButton]`s that will be displayed
    init(
        callToActionBarButton: CallToActionButton?,
        ctaWidthPercentage: WidthPercentFormat = .fifty,
        buttons: [TitleOrIconButton]
    )
    {
        self.init(
            callToActionBarButton: callToActionBarButton?.button,
            ctaWidth: ctaWidthPercentage,
            featureButtons: buttons
        )
    }

    /// ActionBar with `CTAButton` and `infoI` with direct parameters.
    /// - Parameters:
    ///   - ctaTitle: The title of the CTA Button
    ///   - ctaSubtitle: The subtitle of the CTA Button
    ///   - ctaAction: The action of the CTA Button
    ///   - ctaWidthPercentage: The width of the CTA Button
    init(
        ctaTitle: String,
        ctaSubtitle: String?,
        ctaAction: @escaping () -> Void,
        ctaWidthPercentage: WidthPercentFormat = .fifty
    )
    {
        let ctaButton: TitleOrIconButton = TitleOrIconButton(
            title: ctaTitle,
            subtitle: ctaSubtitle,
            tint: UIColor.white,
            backgroundColor: ActionBarProperties.defaultCTAColor,
            action: ctaAction
        )

        self.init(
            callToActionBarButton: ctaButton,
            ctaWidth: ctaWidthPercentage,
            featureButtons: nil
        )
    }

    /// ActionBar with `CTAButton` and `FeatureButton`, that are initialized by just giving
    /// a `String` for the Title, an optional `String` for the subtitle and the action with a `() -> Void`.
    /// - Parameters:
    ///   - callToActionBarButton: The optional `CTAButton` that will be displayed
    ///   - ctaWidthPercentage: How much percent the `CTAButton`should take
    ///   - buttonTextAndActions: The title, subtitle and `() -> Void` that make up the `FeatureButton`s
    init(
        callToActionBarButton: CallToActionButton?,
        ctaWidthPercentage: WidthPercentFormat = .fifty,
        buttonTextAndActions: [(String, String?, () -> Void)]
    )
    {
        var buttons: [TitleOrIconButton] = []
        for buttonProp in buttonTextAndActions
        {
            buttons.append(
                TitleOrIconButton(
                    title: buttonProp.0,
                    subtitle: buttonProp.1,
                    tint: ActionBarProperties.defaultTintColor,
                    action: buttonProp.2
                )
            )
        }
        self.init(
            callToActionBarButton: callToActionBarButton?.button,
            ctaWidth: ctaWidthPercentage,
            featureButtons: buttons
        )
    }
}

// MARK: TitleOrIconButton

/// The tint colors of both titles are unified in one argument, because I don't see the point of having them different.
/// Add if needed.
public extension ABP.TitleOrIconButton
{
    /// A `TitleOrIconButton` with a `Title`
    /// - Parameters:
    ///   - title: The title as a `String` in the tint color
    ///   - subtitle: An optional subtitle as a `String`
    ///   - alignment: How the text is aligned
    ///   - tint: The `UIColor` for the title and subtitle.
    ///   - backgroundColor: An alternative background `UIColor` for this button, predefined as transparent
    ///   - action: The action of the button as a `() -> Void`
    init(
        title: String,
        subtitle: String? = nil,
        alignment: NSTextAlignment = .center,
        tint: UIColor,
        backgroundColor: UIColor = .clear,
        action: (() -> Void)?
    )
    {
        titleOrIcon = .title(
            ABP.Title(text: title, tint: tint, alignment: alignment, font: ABP.Title.defaultTitleFont)
        )

        self.subtitle = ABP.Title(
            text: subtitle,
            tint: tint,
            alignment: alignment,
            font: ABP.Title.defaultSubTitleFont
        )

        self.backgroundColor = backgroundColor
        self.action = action
    }

    /// A `TitleOrIconButton` with an `Icon`
    /// - Parameters:
    ///   - icon: An icon, chosen from the `IconsIdentifier` enum in the tint color
    ///   - subtitle: An optional subtitle as a `String`
    ///   - tint: The optional `UIColor` for the icon and subtitle, predefined as interactiveBlue
    ///   - backgroundColor: An alternative background `UIColor` for this button, predefined as transparent
    ///   - action: The action of the button as a `() -> Void`
    init(
        icon: UIImage,
        subtitle: String? = nil,
        tint: UIColor = ActionBarProperties.defaultTintColor,
        backgroundColor: UIColor = .clear,
        action: (() -> Void)?
    )
    {
        titleOrIcon = .icon(
            ABP.Icon(image: icon, tint: tint)
        )
        self.subtitle = ABP.Title(text: subtitle, tint: tint, font: ABP.Title.defaultSubTitleFont)
        self.backgroundColor = backgroundColor
        self.action = action
    }
}

// MARK: - CallToActionButton

public extension ABP.CallToActionButton
{
    /// A `CallToActionButton` with a `Title`
    /// - Parameters:
    ///   - title: The title as a `String` in the tint color
    ///   - subtitle: An optional subtitle as a `String`
    ///   - alignment: How the text is aligned
    ///   - tint: The optional `UIColor` for the title and subtitle, predefined as white
    ///   - backgroundColor: An alternative background `UIColor` for this button, predefined as cewe red
    ///   - action: The action of the button as a `() -> Void`
    init(
        title: String,
        subtitle: String? = nil,
        alignment: NSTextAlignment = .center,
        tint: UIColor = .white,
        backgroundColor: UIColor = ActionBarProperties.defaultCTAColor,
        action: (() -> Void)?
    )
    {
        button = ABP.TitleOrIconButton(
            title: title,
            subtitle: subtitle,
            alignment: alignment,
            tint: tint,
            backgroundColor: backgroundColor,
            action: action
        )
    }

    /// A `CallToActionButton` with an `Icon`
    /// - Parameters:
    ///   - icon: An icon, chosen from the `IconsIdentifier` enum in the tint color
    ///   - subtitle: An optional subtitle as a `String`
    ///   - tint: The optional `UIColor` for the icon and subtitle, predefined as interactiveBlue
    ///   - backgroundColor: An alternative background `UIColor` for this button, predefined as cewe red
    ///   - action: The action of the button as a `() -> Void`
    init(
        icon: UIImage,
        subtitle: String? = nil,
        tint: UIColor = .white,
        backgroundColor: UIColor = ActionBarProperties.defaultCTAColor,
        action: (() -> Void)?
    )
    {
        button = ABP.TitleOrIconButton(
            icon: icon,
            subtitle: subtitle,
            tint: tint,
            backgroundColor: backgroundColor,
            action: action
        )
    }

}

// MARK: TitleOrIcon

public extension ABP.TitleOrIcon
{

    /// Simple init with a Title
    /// - Parameters:
    ///   - text: The title
    ///   - tint: The tint for the title
    ///   - alignment: How the text is aligned
    ///   - font: The font for the title
    init(
        text: String,
        tint: UIColor = ActionBarProperties.defaultTintColor,
        alignment: NSTextAlignment = .center,
        font: UIFont
    )
    {
        self = .title(ActionBarProperties.Title(
            text: text,
            tint: tint,
            alignment: alignment,
            font: font
        )
        )
    }

    /// Optional init with a title
    /// - Parameters:
    ///   - text: The title
    ///   - tint: The tint for the title
    ///   - alignment: How the text is aligned
    ///   - font: the font for the title
    init?(
        text: String?,
        tint: UIColor = ActionBarProperties.defaultTintColor,
        alignment: NSTextAlignment = .center,
        font: UIFont
    )
    {
        if let text = text
        {
            self = .title(ActionBarProperties.Title(
                text: text,
                tint: tint,
                alignment: alignment,
                font: font
            )
            )
        }
        else
        {
            return nil
        }
    }

    /// Simple init with an Icon
    /// - Parameters:
    ///   - icon: The icon as enum
    ///   - tint: The tint for the icon
    init(icon: UIImage, tint: UIColor = ActionBarProperties.defaultTintColor)
    {
        self = .icon(ActionBarProperties.Icon(image: icon, tint: tint))
    }

    init?(
        title: String?,
        icon: UIImage?,
        tint: UIColor,
        alignment: NSTextAlignment = .center,
        font: UIFont
    )
    {
        // Make sure either title OR icon are set, but not both
        if let title = title, icon == nil
        {
            self = .title(ActionBarProperties.Title(
                text: title,
                tint: tint,
                font: font
            )
            )
        }
        else if let icon = icon, title == nil
        {
            self = .icon(ActionBarProperties.Icon(image: icon, tint: tint))
        }
        else
        {
            return nil
        }
    }
}

// MARK: Title

public extension ABP.Title
{

    /// Optional init
    /// - Parameters:
    ///   - text: The text for the title
    ///   - tint: The tint for the text
    ///   - alignment: How the text is aligned
    ///   - font: The font for the title
    init?(
        text: String?,
        tint: UIColor = ActionBarProperties.defaultTintColor,
        alignment: NSTextAlignment = .center,
        font: UIFont
    )
    {
        if let text = text
        {
            self.text = text
            self.tint = tint
            self.alignment = alignment
            self.font = font
        }
        else
        {
            return nil
        }
    }

    static let defaultCTATitleFont: UIFont = UIFont.boldSystemFont(ofSize: 12)
    static let defaultCTASubTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 10)

    static let defaultTitleFont: UIFont = UIFont.systemFont(ofSize: 12)
    static let defaultSubTitleFont: UIFont = UIFont.systemFont(ofSize: 10)
}
