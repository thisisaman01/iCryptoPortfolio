//
//  Models.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

import Foundation

// MARK: - Portfolio Model
struct Portfolio: Codable {
    let totalValue: Double
    let currency: String
    let change24h: Double
    let changePercentage24h: Double
    let lastUpdated: Date
    
    var formattedValue: String {
        return NumberFormatter.currency.string(from: NSNumber(value: totalValue)) ?? "₹0"
    }
    
    var formattedChange: String {
        let prefix = changePercentage24h >= 0 ? "+" : ""
        return "\(prefix)\(String(format: "%.2f", changePercentage24h))%"
    }
    
    var isPositive: Bool {
        return changePercentage24h >= 0
    }
}

// MARK: - Asset Model
struct Asset: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let price: Double
    let change24h: Double
    let changePercentage24h: Double
    let holdings: Double
    let iconName: String
    
    var totalValue: Double {
        return price * holdings
    }
    
    var formattedPrice: String {
        return NumberFormatter.currency.string(from: NSNumber(value: price)) ?? "₹0"
    }
    
    var formattedTotalValue: String {
        return NumberFormatter.currency.string(from: NSNumber(value: totalValue)) ?? "₹0"
    }
    
    var formattedHoldings: String {
        return String(format: "%.6f", holdings)
    }
    
    var formattedChange: String {
        let prefix = changePercentage24h >= 0 ? "+" : ""
        return "\(prefix)\(String(format: "%.2f", changePercentage24h))%"
    }
    
    var isPositive: Bool {
        return changePercentage24h >= 0
    }
}

// MARK: - Transaction Model
struct Transaction: Codable, Identifiable {
    let id: String
    let type: TransactionType
    let amount: Double
    let currency: String
    let date: Date
    let status: TransactionStatus
    let hash: String?
    let fee: Double?
    let toAddress: String?
    let fromAddress: String?
    
    enum TransactionType: String, Codable, CaseIterable {
        case receive = "Receive"
        case send = "Send"
        case exchange = "Exchange"
        
        var icon: String {
            switch self {
            case .receive: return "arrow.down.circle.fill"
            case .send: return "arrow.up.circle.fill"
            case .exchange: return "arrow.2.circlepath.circle.fill"
            }
        }
        
        var color: UIColor {
            switch self {
            case .receive: return Constants.Colors.greenPositive
            case .send: return Constants.Colors.redNegative
            case .exchange: return Constants.Colors.primaryBlue
            }
        }
    }
    
    enum TransactionStatus: String, Codable {
        case pending = "Pending"
        case completed = "Completed"
        case failed = "Failed"
        
        var color: UIColor {
            switch self {
            case .pending: return UIColor.systemOrange
            case .completed: return Constants.Colors.greenPositive
            case .failed: return Constants.Colors.redNegative
            }
        }
    }
    
    var formattedAmount: String {
        let prefix = type == .receive ? "+" : ""
        return "\(prefix)\(String(format: "%.6f", amount))"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
    
    var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Chart Data Model
struct ChartDataPoint: Codable {
    let timestamp: Date
    let value: Double
}

// MARK: - Exchange Rate Model
struct ExchangeRate: Codable {
    let fromCurrency: String
    let toCurrency: String
    let rate: Double
    let spread: Double
    let gasFee: Double
    
    var formattedRate: String {
        return "1 \(fromCurrency) = ₹\(String(format: "%.2f", rate))"
    }
    
    var formattedSpread: String {
        return String(format: "%.2f", spread) + "%"
    }
    
    var formattedGasFee: String {
        return "₹\(String(format: "%.2f", gasFee))"
    }
}

// MARK: - Enhanced Data Service
protocol DataServiceProtocol: AnyObject {
    func getPortfolio(completion: @escaping (Portfolio) -> Void)
    func getAssets(completion: @escaping ([Asset]) -> Void)
    func getTransactions(completion: @escaping ([Transaction]) -> Void)
    func getChartData(timeframe: String, completion: @escaping ([ChartDataPoint]) -> Void)
    func getExchangeRate(from: String, to: String, completion: @escaping (ExchangeRate) -> Void)
    func sendTransaction(to: String, amount: Double, currency: String, completion: @escaping (Bool, Error?) -> Void)
}
