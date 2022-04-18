//
//  ActionBarTitles.swift
//  targets
//
//  Created by Naziyok, Tolga on 30.01.20.
//  Copyright © 2020 CEWE. All rights reserved.
//

import Foundation
import UIKit

/// This view represents the title or icon with an optional subtitle.
/// As a `UIStackView`, it handles presents itself correctly wether
/// there is a subtitle or not.
///
/// ```
/// no subtitle    with subtitle
///
///             |    Title/Icon
///    Title    |
///             |    Subtitle
/// ```
public final class ActionBarTitlesView: UIStackView
{

    // MARK: Private Properties

    private var pTitleLabel: UILabel?
    private var pSubtitleLabel: UILabel?
    private var pIconImageView: UIImageView?

    init(
        titleOrIconProperties: ActionBarProperties.TitleOrIcon,
        subtitleProperties: ActionBarProperties.Title?
    )
    {
        super.init(frame: CGRect.zero)
        configureStackView()
        setup(titleOrIconProperties, subtitleProperties)
    }

    required init(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions

private extension ActionBarTitlesView
{
    func configureStackView()
    {
        axis = .vertical
        distribution = .fillEqually
        isBaselineRelativeArrangement = true
    }

    // MARK: - Setup/Create

    func setup(
        _ titleOrIconProperties: ActionBarProperties.TitleOrIcon,
        _ subtitleProperties: ActionBarProperties.Title?
    )
    {
        isUserInteractionEnabled = false
        if let subProperties: ABP.Title = subtitleProperties
        {
            createTitleOrIcon(titleOrIconProperties)
            createSubtitle(subProperties)
        }
        else
        {
            createTitleOrIcon(titleOrIconProperties)
        }
    }

    func createTitleOrIcon(_ titleOrIconProperties: ActionBarProperties.TitleOrIcon)
    {
        switch titleOrIconProperties
        {
            case let .title(title):
                createTitle(title)
            case let .icon(icon):
                createIcon(icon)
        }
    }

    func createTitle(_ titleProperties: ABP.Title)
    {
        let titleLabel: UILabel = UILabel.newAutoLayout()
        pTitleLabel = titleLabel

        updateLabel(titleLabel, properties: titleProperties)

        insertArrangedSubview(titleLabel, at: 0)
    }

    func createIcon(_ iconProperties: ABP.Icon)
    {
        let iconImageView = UIImageView(image: iconProperties.image)

        pIconImageView = iconImageView
        iconImageView.contentMode = .center
        insertArrangedSubview(iconImageView, at: 0)
    }

    func createSubtitle(_ subProperties: ABP.Title)
    {
        let subtitle: UILabel = UILabel.newAutoLayout()
        pSubtitleLabel = subtitle

        updateLabel(subtitle, properties: subProperties)

        addArrangedSubview(subtitle)
    }

    // MARK: - Update / Remove

    func updateTitleOrIcon(_ titleOrIconProperties: ActionBarProperties.TitleOrIcon, hasSubtitle: Bool)
    {
        switch titleOrIconProperties
        {
            case let .title(titleProperties):
                removeIcon()
                updateTitle(titleProperties, hasSubtitle)
            case let .icon(iconProperties):
                removeTitle()
                updateIcon(iconProperties, hasSubtitle)
        }
    }

    func removeIcon()
    {
        guard let iconView: UIImageView = pIconImageView else { return }

        removeArrangedSubview(iconView)
        pIconImageView?.image = nil
        pIconImageView = nil
    }

    func removeTitle()
    {
        guard let titleLabel: UILabel = pTitleLabel else { return }

        removeArrangedSubview(titleLabel)
        pTitleLabel = nil
    }

    func updateTitle(_ titleProperties: ActionBarProperties.Title, _ hasSubtitle: Bool)
    {
        if let titleLabel: UILabel = pTitleLabel
        {
            updateLabel(titleLabel, properties: titleProperties)
        }
        else
        {
            createTitle(titleProperties)
        }
    }

    func updateIcon(_ iconProperties: ActionBarProperties.Icon, _ hasSubtitle: Bool)
    {
        if let iconImage: UIImageView = pIconImageView
        {
            iconImage.image = iconProperties.image
        }
        else
        {
            createIcon(iconProperties)
        }
    }

    func updateSubtitle(_ subtitleProperties: ActionBarProperties.Title)
    {
        if let subtitleLabel: UILabel = pSubtitleLabel
        {
            updateLabel(subtitleLabel, properties: subtitleProperties)
        }
        else
        {
            createSubtitle(subtitleProperties)
        }
    }

    func removeSubtitle()
    {
        guard let subtitleLabel: UILabel = pSubtitleLabel else { return }

        subtitleLabel.removeFromSuperview()
        pSubtitleLabel = nil
    }

    func updateLabel(_ label: UILabel, properties: ActionBarProperties.Title)
    {
        label.font = properties.font
        label.animateFormattedTextChange(properties.text)
        label.textColor = properties.tint
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.05
        label.textAlignment = properties.alignment

    }
}

// MARK: - Internal Functions

extension ActionBarTitlesView
{

    /// Updates this view with the given properties
    /// - Parameters:
    ///   - titleOrIconProperties: The applied properties for the title or icon
    ///   - subtitleProperties: The optional applied properties for the subtitle
    func update(
        _ titleOrIconProperties: ActionBarProperties.TitleOrIcon,
        _ subtitleProperties: ActionBarProperties.Title? = nil
    )
    {
        if let subProperties: ABP.Title = subtitleProperties
        {
            updateTitleOrIcon(titleOrIconProperties, hasSubtitle: true)
            updateSubtitle(subProperties)
        }
        else
        {
            updateTitleOrIcon(titleOrIconProperties, hasSubtitle: false)
            removeSubtitle()
        }

    }
}

private extension UILabel
{
    /// Animated the text change to the new formatted text of the label
    func animateFormattedTextChange(_ newText: String?)
    {
        // TODO: Animation and formatted text
        let animation = CATransition()
        animation.duration = 0.75

        layer.add(animation, forKey: CATransitionType.fade.rawValue)
        
        text = newText
//
//        attributedText = newText?.toFormattedText(withFont: font)
    }
}
