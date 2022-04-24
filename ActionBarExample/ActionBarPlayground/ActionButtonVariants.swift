//
//  ActionButtonVariants.swift
//  ActionBarExample
//
//  Created by Naziyok, Tolga on 18.04.22.
//

import Foundation
import UIKit
import ActionBar

typealias ABP = ActionBarProperties

extension ActionBarProperties
{
    static let ctaButton: ABP.CallToActionButton = ABP.CallToActionButton(
        icon: UIImage.actions,
        subtitle: "Test subtitle",
        action: { print("cta Button pressed!") }
    )

    static let editButton: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
        icon: UIImage.strokedCheckmark,
        action: { print("edit Button pressed!") }
    )

    static let backButton: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
        icon: UIImage.checkmark,
        subtitle: "Test subtitle",
        action: { print("back Button pressed!") }
    )

    static let deleteButton: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
        icon: UIImage.remove,
        tint: .systemRed,
        action: { print("delete Button pressed!") }
    )

    static let shareButton: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
        icon: UIImage.add,
        subtitle: "Share",
        tint: .systemGreen,
        action: { print("abort Button pressed!") }
    )

    static let editButtonText: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
        title: "Edit",
        tint: ActionBarProperties.defaultTintColor,
        action: { print("edit Button pressed!") }

    )

    static let backButtonText: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
        title: "Back",
        subtitle: "Test subtitle",
        tint: ActionBarProperties.defaultTintColor,
        action: { print("back Button pressed!") }
    )

    static let deleteButtonText: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
        title: "Delete",
        tint: .systemRed,
        action: { print("delete Button pressed!") }
    )

    static let shareButtonText: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
        title: "Share",
        subtitle: "Share",
        tint: .systemGreen,
        action: { print("abort Button pressed!") }
    )

}
