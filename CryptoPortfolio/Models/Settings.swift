//
//  Settings.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem {
    let title: String
    let type: SettingsItemType
    let subtitle: String?
    let action: SettingsAction
    
    init(title: String, type: SettingsItemType, subtitle: String? = nil, action: SettingsAction) {
        self.title = title
        self.type = type
        self.subtitle = subtitle
        self.action = action
    }
}

enum SettingsItemType {
    case toggle
    case disclosure
}

enum SettingsAction {
    case toggleTheme
    case selectCurrency
    case togglePriceAlerts
    case toggleTransactionUpdates
    case toggleBiometric
    case selectAutoLock
    case openHelp
    case contactSupport
    case rateApp
}

// MARK: - Settings Table View Extensions
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsData[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        let item = settingsData[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = settingsData[indexPath.section].items[indexPath.row]
        handleSettingsAction(item.action)
    }
    
    private func handleSettingsAction(_ action: SettingsAction) {
        switch action {
        case .toggleTheme:
            ThemeManager.shared.toggleTheme()
        case .rateApp:
            // Implement app store rating
            break
        default:
            // Implement other actions......
            break
        }
    }
}

// MARK: - Settings Table View Cell
class SettingsTableViewCell: UITableViewCell {
    private let toggle = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        toggle.onTintColor = Constants.Colors.primaryBlue
    }
    
    func configure(with item: SettingsItem) {
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
        
        switch item.type {
        case .toggle:
            accessoryView = toggle
            accessoryType = .none
        case .disclosure:
            accessoryView = nil
            accessoryType = .disclosureIndicator
        }
    }
}
