//
//  SettingsViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

// MARK: - Settings View Controller
class SettingsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    public let settingsData = [
        SettingsSection(title: "Appearance", items: [
            SettingsItem(title: "Dark Mode", type: .toggle, action: .toggleTheme),
            SettingsItem(title: "Currency", type: .disclosure, subtitle: "INR", action: .selectCurrency)
        ]),
        SettingsSection(title: "Notifications", items: [
            SettingsItem(title: "Price Alerts", type: .toggle, action: .togglePriceAlerts),
            SettingsItem(title: "Transaction Updates", type: .toggle, action: .toggleTransactionUpdates)
        ]),
        SettingsSection(title: "Security", items: [
            SettingsItem(title: "Biometric Authentication", type: .toggle, action: .toggleBiometric),
            SettingsItem(title: "Auto-Lock", type: .disclosure, subtitle: "1 minute", action: .selectAutoLock)
        ]),
        SettingsSection(title: "Support", items: [
            SettingsItem(title: "Help Center", type: .disclosure, action: .openHelp),
            SettingsItem(title: "Contact Support", type: .disclosure, action: .contactSupport),
            SettingsItem(title: "Rate App", type: .disclosure, action: .rateApp)
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsView()
    }
    
    private func setupSettingsView() {
        title = "Settings"
        view.backgroundColor = .systemGroupedBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
