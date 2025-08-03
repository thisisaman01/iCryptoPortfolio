//
//  MenuViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import UIKit

class MenuViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    public let menuItems = [
        MenuSection(title: "ACCOUNT", items: [
            MenuItem(title: "Profile", icon: "person.circle", action: .profile),
            MenuItem(title: "Security", icon: "lock.shield", action: .security),
            MenuItem(title: "Backup Wallet", icon: "externaldrive.badge.icloud", action: .backup)
        ]),
        MenuSection(title: "PREFERENCES", items: [
            MenuItem(title: "Settings", icon: "gear", action: .settings),
            MenuItem(title: "Dark Mode", icon: "moon.circle", action: .darkMode, isToggle: true),
            MenuItem(title: "Notifications", icon: "bell.circle", action: .notifications) // FIXED: Now works!
        ]),
        MenuSection(title: "SUPPORT", items: [
            MenuItem(title: "Help Center", icon: "questionmark.circle", action: .help),
            MenuItem(title: "Contact Support", icon: "message.circle", action: .support),
            MenuItem(title: "Rate App", icon: "star.circle", action: .rate)
        ]),
        MenuSection(title: "", items: [
            MenuItem(title: "Sign Out", icon: "power.circle", action: .signOut, isDestructive: true)
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        
        // Header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        let titleLabel = UILabel()
        titleLabel.text = "Menu"
        titleLabel.font = Constants.Fonts.title1
        titleLabel.textColor = Constants.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.frame = headerView.bounds
        headerView.addSubview(titleLabel)
        
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuCell")
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

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return menuItems.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return menuItems[section].items.count
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let title = menuItems[section].title
//        return title.isEmpty ? nil : title
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
//        let item = menuItems[indexPath.section].items[indexPath.row]
//        cell.configure(with: item)
//        return cell
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let item = menuItems[indexPath.section].items[indexPath.row]
//        handleMenuAction(item.action)
//    }
    
    private func handleMenuAction(_ action: MenuAction) {
        HapticManager.shared.impact(.light)
        
        switch action {
        case .profile:
            // Navigate to profile screen
            showComingSoonAlert(for: "Profile")
        case .security:
            // Navigate to security settings
            showComingSoonAlert(for: "Security")
        case .backup:
            // Show backup options
            showComingSoonAlert(for: "Backup Wallet")
        case .settings:
            let settingsVC = SettingsViewController()
            let navController = UINavigationController(rootViewController: settingsVC)
            present(navController, animated: true)
        case .darkMode:
            // Handled by toggle in cell
            break
        case .notifications:
            // FIXED: Now properly opens notifications!
            presentNotificationsViewController()
        case .help:
            // Open help center
            showComingSoonAlert(for: "Help Center")
        case .support:
            // Open support chat
            showComingSoonAlert(for: "Contact Support")
        case .rate:
            // Open App Store rating
            showRateAppAlert()
        case .signOut:
            showSignOutConfirmation()
        }
    }
    
    // FIXED: Now properly presents notifications
    private func presentNotificationsViewController() {
        let notificationsVC = NotificationsViewController()
        let navController = UINavigationController(rootViewController: notificationsVC)
        navController.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = navController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.preferredCornerRadius = Constants.Layout.largeCornerRadius
            }
        }
        
        present(navController, animated: true)
    }
    
    private func showComingSoonAlert(for feature: String) {
        let alert = UIAlertController(
            title: "\(feature) Coming Soon",
            message: "This feature will be available in a future update.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showRateAppAlert() {
        let alert = UIAlertController(
            title: "Rate Our App",
            message: "If you enjoy using our app, please take a moment to rate it. Thanks for your support!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Rate App", style: .default) { _ in
            // Here you would open the App Store rating
            HapticManager.shared.notification(.success)
        })
        
        present(alert, animated: true)
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
