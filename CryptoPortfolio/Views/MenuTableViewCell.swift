//
//  MenuTableViewCell.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class MenuTableViewCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let toggle = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .default
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = Constants.Colors.primaryBlue
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        titleLabel.font = Constants.Fonts.body
        titleLabel.textColor = Constants.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        toggle.onTintColor = Constants.Colors.primaryBlue
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -8),
            
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: MenuItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        
        if item.isDestructive {
            titleLabel.textColor = UIColor.systemRed
            iconImageView.tintColor = UIColor.systemRed
        } else {
            titleLabel.textColor = Constants.Colors.textPrimary
            iconImageView.tintColor = Constants.Colors.primaryBlue
        }
        
        if item.isToggle {
            toggle.isHidden = false
            accessoryType = .none
            
            if item.action == .darkMode {
                toggle.isOn = ThemeManager.shared.isDarkMode
            }
        } else {
            toggle.isHidden = true
            accessoryType = .disclosureIndicator
        }
    }
    
    @objc private func toggleChanged() {
        // Handle toggle changes here
        if !toggle.isHidden {
            ThemeManager.shared.toggleTheme()
        }
    }
}

extension MenuViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = menuItems[section].title
        return title.isEmpty ? nil : title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        let item = menuItems[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = menuItems[indexPath.section].items[indexPath.row]
        handleMenuAction(item.action)
    }
    
    private func handleMenuAction(_ action: MenuAction) {
        HapticManager.shared.impact(.light)
        
        switch action {
        case .profile:
            // Navigate to profile screen
            break
        case .security:
            // Navigate to security settings
            break
        case .backup:
            // Show backup options
            break
        case .settings:
            let settingsVC = SettingsViewController()
            let navController = UINavigationController(rootViewController: settingsVC)
            present(navController, animated: true)
        case .darkMode:
            // Handled by toggle
            break
        case .notifications:
            // Navigate to notification settings
            break
        case .help:
            // Open help center
            break
        case .support:
            // Open support chat
            break
        case .rate:
            // Open App Store rating
            break
        case .signOut:
            showSignOutConfirmation()
        }
    }
    
    private func showSignOutConfirmation() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            // Handle sign out
            self.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
}
