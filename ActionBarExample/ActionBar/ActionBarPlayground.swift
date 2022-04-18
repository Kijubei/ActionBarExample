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

final class ActionBarPlayground: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: Private Properties
    
    private var propertiesList: [ActionBarProperties] = []
    private let tableView: UITableView = UITableView()

}

// MARK: UIKit

extension ActionBarPlayground
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTableView()
        combineActionBarVariants()
        
        // Choose a Actionbar to display at the bottom
//        setupRegularActionbar()
//        setupSpecialActionbar1()
        setupSpecialActionbar2()
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

}

// MARK: - Private API

private extension ActionBarPlayground
{
    func setupTableView()
    {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .darkGray
        tableView.separatorColor = .darkGray
        
        view.addSubview(tableView)
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    /// First, create arrays of all setting variants. Second, combine all possible setting variants and store them in `propertiesList`.
    func combineActionBarVariants()
    {
        typealias ABP = ActionBarProperties

        let ctaSettings: [ABP.CallToActionButton?] = [ABP.ctaButton, nil]
        let ctaWidthSettings: [ABP.WidthPercentFormat] = [.twenty, .twentyfive, .thirty, .fifty]
        let buttonSettings: [[ABP.TitleOrIconButton]] = [
            [ABP.editButton],
            [ABP.editButton, ABP.backButton],
            [ABP.editButton, ABP.backButton, ABP.deleteButton],
            [ABP.editButton, ABP.backButton, ABP.deleteButton, ABP.shareButton],
            [ABP.editButtonText],
            [ABP.editButtonText, ABP.backButtonText],
            [ABP.editButtonText, ABP.backButtonText, ABP.deleteButtonText],
            [ABP.editButtonText, ABP.backButtonText, ABP.deleteButtonText, ABP.shareButtonText],
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

        actionbarManager.actionBarView.autoPinEdge(toSuperviewEdge: .left)
        actionbarManager.actionBarView.autoPinEdge(toSuperviewEdge: .right)
        actionbarManager.actionBarView.autoPinEdge(toSuperviewSafeArea: .bottom)
    }

    func setupSpecialActionbar1()
    {
        let alternativeABManager: ActionBarManager = ActionBarManager()

        view.addSubview(alternativeABManager.actionBarView)

        alternativeABManager.actionBarView.autoPinEdge(toSuperviewEdge: .left)
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewEdge: .right)
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewSafeArea: .bottom)

        alternativeABManager.add(buttonType: .cta, title: "Power und ein sehr langer Titel", subtitle: "is <u>maxed</u>")
        {
            alternativeABManager.update(buttonType: .cta, subtitle: "")
        }

        alternativeABManager.update(buttonType: .cta, title: "Weakness")
    }

    func setupSpecialActionbar2()
    {
        let alternativeABManager: ActionBarManager = ActionBarManager()

        view.addSubview(alternativeABManager.actionBarView)

        alternativeABManager.actionBarView.autoPinEdge(toSuperviewEdge: .left)
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewEdge: .right)
        alternativeABManager.actionBarView.autoPinEdge(toSuperviewSafeArea: .bottom)

        alternativeABManager.add(buttonType: .cta, title: "Power", subtitle: "maxed")
        {
            alternativeABManager.update(buttonType: .cta, subtitle: "")
        }

        guard let managerButtonIndex: ButtonIndex = alternativeABManager.add(
            buttonType: .featureButton,
            title: "Manager Button",
            subtitle: "löst Probleme",
            action: managerButtonAction
        ) else { return }

        alternativeABManager.update(buttonType: .featureButton, icon: UIImage.add, buttonIndex: managerButtonIndex)

        guard let laserButtonIndex: ButtonIndex = alternativeABManager.add(
            buttonType: .featureButton,
            title: "Laser Beam",
            subtitle: "blendendes Argument",
            tint: .brown,
            action: {
                alternativeABManager.hide(buttonType: .cta)
                alternativeABManager.update(buttonType: .featureButton, tint: .green, buttonIndex: managerButtonIndex)
            }
        ) else { return }

        alternativeABManager.update(buttonType: .cta, title: "Weakness")
        alternativeABManager.update(buttonType: .cta, subtitle: "sub <u>power</u>")
        alternativeABManager.update(buttonType: .featureButton, title: "Useless", subtitle: "schon immer", buttonIndex: managerButtonIndex)
        alternativeABManager.update(buttonType: .featureButton, subtitle: "hot", buttonIndex: laserButtonIndex)
    }
    
    func managerButtonAction()
    {
        let alertController: UIAlertController = UIAlertController(title: "Attention", message: "Just a test", preferredStyle: .alert)
        
        self.present(alertController, animated: true)
        {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alertController.view.superview?.addGestureRecognizer(gesture)
        }
    }

    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }

}
