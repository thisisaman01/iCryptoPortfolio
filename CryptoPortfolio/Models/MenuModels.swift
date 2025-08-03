//
//  MenuModels.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

struct MenuSection {
    let title: String
    let items: [MenuItem]
}

struct MenuItem {
    let title: String
    let icon: String
    let action: MenuAction
    let isToggle: Bool
    let isDestructive: Bool
    
    init(title: String, icon: String, action: MenuAction, isToggle: Bool = false, isDestructive: Bool = false) {
        self.title = title
        self.icon = icon
        self.action = action
        self.isToggle = isToggle
        self.isDestructive = isDestructive
    }
}

enum MenuAction {
    case profile
    case security
    case backup
    case settings
    case darkMode
    case notifications
    case help
    case support
    case rate
    case signOut
}
