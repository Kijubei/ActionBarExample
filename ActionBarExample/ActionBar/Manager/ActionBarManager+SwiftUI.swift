//
//  ActionBarManager+SwiftUI.swift
//
//
//  Created by Naziyok, Tolga on 06.04.21.
//

import Foundation
import SwiftUI

/// Our `ActionBarManager` component for SwiftUI.
///
/// For now, it offers limited functionality until we gain more knowledge in SwiftUI.
/// This will be done in the future Ticket `CFWI-12084`
///
public struct ActionBar: UIViewRepresentable
{
    private let actionbarManager: ActionBarManager

    /// Init with fully configured `ActionBarManager`
    /// - Parameter actionbarManager: The action bar manager
    public init(actionbarManager: ActionBarManager)
    {
        self.actionbarManager = actionbarManager
    }

    public func makeUIView(context: Context) -> ActionBarView
    {
        return actionbarManager.actionBarView
    }

    public func updateUIView(_ actionbar: ActionBarView, context: Context)
    {}
}
