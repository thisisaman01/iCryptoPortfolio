//
//  WalletViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

import UIKit

class WalletViewController: UIViewController {
    private let emptyStateView = EmptyStateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        // Add theme change observer
        ThemeManager.shared.addDelegate(self)
    }
    
    private func setupViews() {
        title = "Wallet"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        // Configure empty state
        emptyStateView.configure(
            image: "wallet.pass",
            title: "Wallet Features Coming Soon",
            subtitle: "We're working hard to bring you advanced wallet management features including multi-currency support, DeFi integration, and more.",
            buttonTitle: "Get Notified",
            action: { [weak self] in
                self?.showNotificationSignup()
            }
        )
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50), // Slightly above center
            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            emptyStateView.widthAnchor.constraint(lessThanOrEqualToConstant: 350), // Max width
            emptyStateView.heightAnchor.constraint(lessThanOrEqualToConstant: 400) // Max height
        ])
    }
    
    private func showNotificationSignup() {
        HapticManager.shared.impact(.light)
        
        let alert = UIAlertController(
            title: "Stay Updated 🔔",
            message: "We'll notify you when advanced wallet features are available.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Notify Me", style: .default) { _ in
            HapticManager.shared.notification(.success)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let successAlert = UIAlertController(
                    title: "✅ You're All Set!",
                    message: "We'll notify you as soon as wallet features are ready.",
                    preferredStyle: .alert
                )
                successAlert.addAction(UIAlertAction(title: "Great!", style: .default))
                self.present(successAlert, animated: true)
            }
        })
        
        present(alert, animated: true)
    }
    
    deinit {
        ThemeManager.shared.removeDelegate(self)
    }
}

extension WalletViewController: ThemeManagerDelegate {
    func themeDidChange() {
        view.backgroundColor = Constants.Colors.backgroundColor
    }
}
