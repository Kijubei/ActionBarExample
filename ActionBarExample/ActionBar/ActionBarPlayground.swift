//
//  ActionBarPlayground.swift
//  targets
//
//  Created by Naziyok, Tolga on 14.01.20.
//  Copyright © 2020 CEWE. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

//private typealias ABP = ActionBarProperties

@objc final class ActionBarPlayground: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var propertiesList: [ActionBarProperties] = []
    private let tableView: UITableView = UITableView()
    private var bottomSafeAreaContainer = UIView() // TODO
    private var regularActionbar: ActionBarManager?
    private var specialActionbar: ActionBarManager?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
        setupProperties()
        setupRegularActionbar()
        setupAlternativeProperties2()
        setConstrains()
    }

    func setupViews()
    {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .darkGray
        tableView.separatorColor = .darkGray
        view.addSubview(tableView)
    }

    func setConstrains()
    {
        tableView.autoPinEdgesToSuperviewEdges()
//        if let safeArea = bottomSafeAreaContainer
//        {
//            tableView.autoPinEdge(.bottom, to: .top, of: safeArea)
//        }
//        else
//        {
//            tableView.autoPinEdge(toSuperviewEdge: .bottom)
//        }

    }

    // swiftlint:disable function_body_length
    func setupProperties()
    {
        let ctaButton: ABP.CallToActionButton = ABP.CallToActionButton(
            icon: UIImage.actions,
            subtitle: "Test subtitle",
            action: {
                let viewController = UIViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        )

        let editButton: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
            icon: UIImage.strokedCheckmark,
            action: { print("edit Button pressed!") }
        )

        let backButton: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
            icon: UIImage.checkmark,
            subtitle: "Test subtitle",
            action: { print("back Button pressed!") }
        )

        let deleteButton: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
            icon: UIImage.remove,
            tint: .systemRed,
            action: { print("delete Button pressed!") }
        )

        let shareButton: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
            icon: UIImage.add,
            subtitle: "Share",
            tint: .systemGreen,
            action: { print("abort Button pressed!") }
        )

        let editButtonText: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
            title: "Edit",
            tint: ActionBarProperties.defaultTintColor,
            action: { print("edit Button pressed!") }

        )

        let backButtonText: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
            title: "Back",
            subtitle: "Test subtitle",
            tint: ActionBarProperties.defaultTintColor,
            action: { print("back Button pressed!") }
        )

        let deleteButtonText: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
            title: "Delete",
            tint: .systemRed,
            action: { print("delete Button pressed!") }
        )

        let shareButtonText: ABP.TitleOrIconButton = ABP.TitleOrIconButton(
            title: "Share",
            subtitle: "Share",
            tint: .systemGreen,
            action: { print("abort Button pressed!") }
        )

        let ctaSettings: [ABP.CallToActionButton?] = [ctaButton, nil]
        let ctaWidthSettings: [ABP.WidthPercentFormat] = [.twenty, .twentyfive, .thirty, .fifty]
        let buttonSettings: [[ABP.TitleOrIconButton]] = [
            [editButton],
            [editButton, backButton],
            [editButton, backButton, deleteButton],
            [editButton, backButton, deleteButton, shareButton],
            [editButtonText],
            [editButtonText, backButtonText],
            [editButtonText, backButtonText, deleteButtonText],
            [editButtonText, backButtonText, deleteButtonText, shareButtonText],
        ]

        for ctaSetting in ctaSettings
        {
            if ctaSetting != nil
            {
                for ctaWidthSetting in ctaWidthSettings
                {
                    for buttonSetting in buttonSettings
                    {
                        let newProperties: ActionBarProperties = ActionBarProperties(
                            callToActionBarButton: ctaSetting,
                            ctaWidthPercentage: ctaWidthSetting,
                            buttons: buttonSetting
                        )

                        propertiesList.append(newProperties)
                    }
                }
            }
            else
            {
                for buttonSetting in buttonSettings
                {
                    let newProperties: ActionBarProperties = ActionBarProperties(
                        callToActionBarButton: ctaSetting,
                        buttons: buttonSetting
                    )

                    propertiesList.append(newProperties)
                }
            }
        }
    }

    func setupRegularActionbar()
    {

        let cta: ActionBarProperties.CallToActionButton = ActionBarProperties.CallToActionButton(
            icon: UIImage.actions,
            subtitle: "Fertisch"
        )
        {}

        let properties: ActionBarProperties = ActionBarProperties(
            callToActionBarButton: cta,
            ctaWidthPercentage: .twentyfive
        )

        let actionbarManager: ActionBarManager = ActionBarManager(properties: properties)

        view.addSubview(actionbarManager.actionBarView)

//        actionbarManager.bottomSafeAreaContainer.autoCreateConstraints()
        actionbarManager.actionBarView.autoPinEdge(toSuperviewEdge: .left)
        actionbarManager.actionBarView.autoPinEdge(toSuperviewEdge: .right)
        actionbarManager.actionBarView.autoPinEdge(toSuperviewSafeArea: .bottom)

        regularActionbar = actionbarManager
    }

    func setupAlternativeProperties1()
    {
        let alternativeABManager: ActionBarManager = ActionBarManager()

        view.addSubview(alternativeABManager.actionBarView)

        alternativeABManager.actionBarView.autoPinEdge(toSuperviewEdge: .left)
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewEdge: .right)
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewSafeArea: .bottom)

        bottomSafeAreaContainer = alternativeABManager.actionBarView

        alternativeABManager.add(buttonType: .cta, title: "Power und ein sehr langer Titel", subtitle: "is <u>maxed</u>")
        {
            alternativeABManager.update(buttonType: .cta, subtitle: "")
        }

//        alternativeABManager.update(buttonType: .cta, title: "Weakness")
        alternativeABManager.update(buttonType: .cta, subtitle: "is <u>low</u>")
    }

    // swiftlint:disable function_body_length
    /// - Tag: PopoverExample1
    func setupAlternativeProperties2()
    {
        let alternativeABManager: ActionBarManager = ActionBarManager()

        view.addSubview(alternativeABManager.actionBarView)

//        alternativeABManager.bottomSafeAreaContainer.autoCreateConstraints()
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewEdge: .left)
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewEdge: .right)
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewSafeArea: .bottom)

        // example to hide actionbar on init
//        alternativeABManager.hide()

        bottomSafeAreaContainer = alternativeABManager.actionBarView

        specialActionbar = alternativeABManager

        alternativeABManager.add(buttonType: .cta, title: "Power", subtitle: "maxed")
        {
            alternativeABManager.update(buttonType: .cta, subtitle: "")
        }

        let managerAction: () -> Void = {
            let label: UILabel = UILabel.newAutoLayout()
            label.text = "Dies ist nur ein Test"
            label.textColor = .black
            label.textAlignment = .center
            let icon: UIImageView = UIImageView()
            icon.image = UIImage.actions
            icon.contentMode = .center

            let stackView: UIStackView = UIStackView(arrangedSubviews: [label, icon])
            stackView.configureForAutoLayout()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.backgroundColor = .yellow

            let alertController: UIAlertController = UIAlertController(title: "Attention", message: "Just a test", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }

        guard let managerButtonIndex: ButtonIndex = alternativeABManager.add(
            buttonType: .featureButton,
            title: "Manager Button",
            subtitle: "löst Probleme",
            action: managerAction
        ) else { return }

        alternativeABManager.update(buttonType: .featureButton, icon: UIImage.add, buttonIndex: managerButtonIndex)

        let laserAction: () -> Void = {
            alternativeABManager.hide(buttonType: .cta)
            alternativeABManager.update(buttonType: .featureButton, tint: .green, buttonIndex: managerButtonIndex)
        }

        guard let laserButtonIndex: ButtonIndex = alternativeABManager.add(
            buttonType: .featureButton,
            title: "Laser Beam",
            subtitle: "blendendes Argument",
            tint: .brown,
            action: laserAction
        ) else { return }

        alternativeABManager.update(buttonType: .cta, title: "Weakness")
        alternativeABManager.update(buttonType: .cta, subtitle: "sub <u>power</u>")
        alternativeABManager.update(buttonType: .featureButton, title: "Useless", subtitle: "schon immer", buttonIndex: managerButtonIndex)
        alternativeABManager.update(buttonType: .featureButton, subtitle: "hot", buttonIndex: laserButtonIndex)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        propertiesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.selectionStyle = .none

        let actionbarManager: ActionBarManager = ActionBarManager(properties: propertiesList[indexPath.row])

        cell.contentView.addSubview(actionbarManager.actionBarView)

        actionbarManager.actionBarView.autoPinEdgesToSuperviewEdges()

        return cell
    }

    @objc func dissmissController()
    {
        dismiss(animated: true, completion: nil)
    }
}
