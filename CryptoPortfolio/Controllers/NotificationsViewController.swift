//
//  NotificationsViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


// MARK: - Notifications View Controller
class NotificationsViewController: UIViewController {
    private let tableView = UITableView()
    
    public let notifications = [
        NotificationItem(
            title: "Price Alert",
            message: "BTC has reached ₹75,00,000",
            time: "2 minutes ago",
            type: .priceAlert,
            isRead: false
        ),
        NotificationItem(
            title: "Transaction Completed",
            message: "Your exchange of ETH to INR was successful",
            time: "1 hour ago",
            type: .transaction,
            isRead: true
        ),
        NotificationItem(
            title: "Security Update",
            message: "New security features available",
            time: "Yesterday",
            type: .security,
            isRead: true
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        title = "Notifications"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Mark All Read",
            style: .plain,
            target: self,
            action: #selector(markAllReadTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func markAllReadTapped() {
        // Mark all notifications as read
        tableView.reloadData()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
