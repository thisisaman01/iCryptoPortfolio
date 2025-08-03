//
//  NotificationModel.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


struct NotificationItem {
    let title: String
    let message: String
    let time: String
    let type: NotificationType
    let isRead: Bool
}

enum NotificationType {
    case priceAlert
    case transaction
    case security
    case general
    
    var icon: String {
        switch self {
        case .priceAlert: return "chart.line.uptrend.xyaxis"
        case .transaction: return "arrow.left.arrow.right.circle"
        case .security: return "shield.checkered"
        case .general: return "bell"
        }
    }
    
    var color: UIColor {
        switch self {
        case .priceAlert: return Constants.Colors.greenPositive
        case .transaction: return Constants.Colors.primaryBlue
        case .security: return UIColor.systemOrange
        case .general: return Constants.Colors.textSecondary
        }
    }
}
