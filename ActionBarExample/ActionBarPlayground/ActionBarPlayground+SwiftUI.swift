//
//  ActionBarPlayground+SwiftUI.swift
//  ActionBarExample
//
//  Created by Naziyok, Tolga on 18.04.22.
//

import Foundation
import SwiftUI

struct ActionBarPlaygroundView : UIViewControllerRepresentable
{
    typealias UIViewControllerType = ActionBarPlayground

    func makeUIViewController(context: Context) -> ActionBarPlayground {
        return ActionBarPlayground()
    }
    
    func updateUIViewController(_ uiViewController: ActionBarPlayground, context: Context) {
        return
    }
    
}
