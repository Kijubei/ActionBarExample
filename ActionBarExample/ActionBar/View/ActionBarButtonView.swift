//
//  ActionBarButtonView.swift
//  targets
//
//  Created by Naziyok, Tolga on 13.01.20.
//  Copyright © 2020 CEWE. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

/// This is a `UIButton` representation of the `CTAButton` and `FeatureButton`.
/// This view should never be initialized directly, in case you need an `ActionBarView`, use the
/// `ActionbarManager` instead.
public final class ActionBarButtonView: UIButton
{
    // MARK: - Private Properties

    private var pAction: (() -> Void)?
    private let pImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private var pTitlesView: ActionBarTitlesView?

    /// Builds a `ActionBarButtonView` according to the properties.
    /// - Parameter properties: These are of type `ActionBarButton`, a protocol that `CTAButton` and `FeatureButton` conform to.
    init(properties: ActionBarProperties.TitleOrIconButton)
    {
        pAction = properties.action
        super.init(frame: CGRect.zero)
        setup(properties)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Setup functions

private extension ActionBarButtonView
{
    /// Sets background, icon, title, subtitle and adds a function to the button
    func setup(_ properties: ActionBarProperties.TitleOrIconButton)
    {
        backgroundColor = properties.backgroundColor

        let titlesView: ActionBarTitlesView = ActionBarTitlesView(
            titleOrIconProperties: properties.titleOrIcon,
            subtitleProperties: properties.subtitle
        )

        pTitlesView = titlesView

        addSubview(titlesView)

        titlesView.autoPinEdge(toSuperviewEdge: .top)
        titlesView.autoPinEdge(toSuperviewEdge: .bottom)

        switch properties.titleOrIcon
        {
            case .title:
                titlesView.autoPinToSuperviewHorizontalEdges(withInset: .horizontalOffset)

            case .icon:
                titlesView.autoPinEdge(toSuperviewEdge: .right)
                titlesView.autoPinEdge(toSuperviewEdge: .left)

        }

        addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    }

    /// Adds a nice effect to a button push and also executes the action
    @objc
    func buttonTap()
    {
        guard let action: (() -> Void) = pAction else { return }

        UIView.doHighlightWithAlpha(view: self, alpha: 0.5, reverse: true)
        pImpactFeedbackGenerator.impactOccurred()
        action()
    }

}

// MARK: Internal functions

extension ActionBarButtonView
{
    /// Updates this view with the given properties
    /// - Parameter buttonProperties: The properties that will be applied
    func update(_ buttonProperties: ActionBarProperties.TitleOrIconButton)
    {
        backgroundColor = buttonProperties.backgroundColor

        if let newAction: () -> Void = buttonProperties.action
        {
            pAction = newAction
        }

        guard let titleView = pTitlesView else { return }

        titleView.update(buttonProperties.titleOrIcon, buttonProperties.subtitle)
    }

}

private extension CGFloat
{
    static let horizontalOffset = UIDevice.current.userInterfaceIdiom == .pad ? 20.0 : 6.0
}
