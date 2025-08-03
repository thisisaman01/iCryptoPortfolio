//
//  MockDataService.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
class MockDataService: DataServiceProtocol {
    static let shared = MockDataService()
    
    private init() {}
    
    func getPortfolio(completion: @escaping (Portfolio) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let portfolio = Portfolio(
                totalValue: 1572342.05,
                currency: "INR",
                change24h: 1342,
                changePercentage24h: 4.6,
                lastUpdated: Date()
            )
            
            DispatchQueue.main.async {
                completion(portfolio)
            }
        }
    }
    
    func getAssets(completion: @escaping ([Asset]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let assets = [
                Asset(
                    id: "bitcoin",
                    symbol: "BTC",
                    name: "Bitcoin",
                    price: 7562502.14,
                    change24h: 233550.45,
                    changePercentage24h: 3.2,
                    holdings: 0.010012,
                    iconName: "bitcoinIcon"
                ),
                Asset(
                    id: "ethereum",
                    symbol: "ETH",
                    name: "Ethereum",
                    price: 179102.50,
                    change24h: 5891.20,
                    changePercentage24h: 3.4,
                    holdings: 2.640,
                    iconName: "ethereumIcon"
                )
            ]
            
            DispatchQueue.main.async {
                completion(assets)
            }
        }
    }
    
    func getTransactions(completion: @escaping ([Transaction]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let transactions = [
                Transaction(
                    id: UUID().uuidString,
                    type: .receive,
                    amount: 0.002126,
                    currency: "BTC",
                    date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                    status: .completed,
                    hash: "0x1234567890abcdef1234567890abcdef12345678",
                    fee: 0.0001,
                    toAddress: "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
                    fromAddress: nil
                ),
                Transaction(
                    id: UUID().uuidString,
                    type: .send,
                    amount: 0.003126,
                    currency: "ETH",
                    date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                    status: .completed,
                    hash: "0xabcdef1234567890abcdef1234567890abcdef12",
                    fee: 0.002,
                    toAddress: "0x742d35Cc6634C0532925a3b8D0Fd7CdaD3A3B8Cd",
                    fromAddress: "0x123d35Cc6634C0532925a3b8D0Fd7CdaD3A3B8Cd"
                ),
                Transaction(
                    id: UUID().uuidString,
                    type: .send,
                    amount: 0.02126,
                    currency: "LTC",
                    date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                    status: .completed,
                    hash: "0x9876543210fedcba9876543210fedcba98765432",
                    fee: 0.001,
                    toAddress: "LQTpS9EvCvs2JGnw5JLWNhKS4aQzUj9sDQ",
                    fromAddress: "LXv2RKL8g3HJd9qBF6Z9X2nHs4aQzUj9s"
                )
            ]
            
            DispatchQueue.main.async {
                completion(transactions)
            }
        }
    }
    
    func getChartData(timeframe: String, completion: @escaping ([ChartDataPoint]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let baseValue = 142340.0
            var dataPoints: [ChartDataPoint] = []
            
            let numberOfPoints = 30
            let timeInterval = self.getTimeInterval(for: timeframe)
            
            for i in 0..<numberOfPoints {
                let timestamp = Date().addingTimeInterval(-Double(numberOfPoints - i) * timeInterval)
                let variation = Double.random(in: -0.1...0.1)
                let trend = sin(Double(i) * 0.3) * 0.05 
                let value = baseValue * (1 + variation + trend + (Double(i) / Double(numberOfPoints)) * 0.2)
                dataPoints.append(ChartDataPoint(timestamp: timestamp, value: value))
            }
            
            DispatchQueue.main.async {
                completion(dataPoints)
            }
        }
    }
    
    func getExchangeRate(from: String, to: String, completion: @escaping (ExchangeRate) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let rate = ExchangeRate(
                fromCurrency: from,
                toCurrency: to,
                rate: 176138.80,
                spread: 0.2,
                gasFee: 422.73
            )
            
            DispatchQueue.main.async {
                completion(rate)
            }
        }
    }
    
    func sendTransaction(to: String, amount: Double, currency: String, completion: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Simulate network delay
            Thread.sleep(forTimeInterval: 2.0)
            
            // Simulate success (90% success rate)
            let success = Double.random(in: 0...1) > 0.1
            
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    let error = NSError(domain: "TransactionError", code: 1001, userInfo: [
                        NSLocalizedDescriptionKey: "Transaction failed. Please try again."
                    ])
                    completion(false, error)
                }
            }
        }
    }
    
    private func getTimeInterval(for timeframe: String) -> TimeInterval {
        switch timeframe.lowercased() {
        case "1h": return 60 * 60 / 30
        case "8h": return 8 * 60 * 60 / 30
        case "1d": return 24 * 60 * 60 / 30
        case "1w": return 7 * 24 * 60 * 60 / 30
        case "1m": return 30 * 24 * 60 * 60 / 30
        case "1y": return 365 * 24 * 60 * 60 / 30
        default: return 24 * 60 * 60 / 30
        }
    }
}

// MARK: - Extensions
extension NumberFormatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    static let crypto: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    static let percentage: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
}

extension Date {
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
