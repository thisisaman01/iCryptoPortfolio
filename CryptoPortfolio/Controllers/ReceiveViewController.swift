//
//  ReceiveViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

// MARK: - Receive View Controller
class ReceiveViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let qrCodeImageView = UIImageView()
    private let addressLabel = UILabel()
    private let copyButton = GradientButton()
    private let shareButton = UIButton(type: .system)
    
    private let walletAddress = "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        generateQRCode()
    }
    
    private func setupViews() {
        title = "Receive Crypto"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // QR Code container
        let qrContainer = CardView()
        qrContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(qrContainer)
        
        let qrTitleLabel = UILabel()
        qrTitleLabel.text = "Scan QR Code"
        qrTitleLabel.font = Constants.Fonts.title3
        qrTitleLabel.textColor = Constants.Colors.textPrimary
        qrTitleLabel.textAlignment = .center
        qrTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        qrContainer.addSubview(qrTitleLabel)
        
        qrCodeImageView.contentMode = .scaleAspectFit
        qrCodeImageView.backgroundColor = .white
        qrCodeImageView.layer.cornerRadius = Constants.Layout.cornerRadius
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        qrContainer.addSubview(qrCodeImageView)
        
        // Address container
        let addressContainer = CardView()
        addressContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addressContainer)
        
        let addressTitleLabel = UILabel()
        addressTitleLabel.text = "Wallet Address"
        addressTitleLabel.font = Constants.Fonts.title3
        addressTitleLabel.textColor = Constants.Colors.textPrimary
        addressTitleLabel.textAlignment = .center
        addressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addressContainer.addSubview(addressTitleLabel)
        
        addressLabel.text = walletAddress
        addressLabel.font = Constants.Fonts.body
        addressLabel.textColor = Constants.Colors.textSecondary
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 0
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressContainer.addSubview(addressLabel)
        
        // Buttons
        copyButton.setTitle("Copy Address", for: .normal)
        copyButton.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(copyButton)
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(Constants.Colors.primaryBlue, for: .normal)
        shareButton.titleLabel?.font = Constants.Fonts.body
        shareButton.backgroundColor = Constants.Colors.cardBackground
        shareButton.layer.cornerRadius = Constants.Layout.cornerRadius
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = Constants.Colors.primaryBlue.cgColor
        shareButton.addTarget(self, action: #selector(shareAddress), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shareButton)
        
        // Setup constraints for card contents
        NSLayoutConstraint.activate([
            // QR container constraints
            qrTitleLabel.topAnchor.constraint(equalTo: qrContainer.topAnchor, constant: Constants.Layout.padding),
            qrTitleLabel.leadingAnchor.constraint(equalTo: qrContainer.leadingAnchor, constant: Constants.Layout.padding),
            qrTitleLabel.trailingAnchor.constraint(equalTo: qrContainer.trailingAnchor, constant: -Constants.Layout.padding),
            
            qrCodeImageView.topAnchor.constraint(equalTo: qrTitleLabel.bottomAnchor, constant: 16),
            qrCodeImageView.centerXAnchor.constraint(equalTo: qrContainer.centerXAnchor),
            qrCodeImageView.widthAnchor.constraint(equalToConstant: 200),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: 200),
            qrCodeImageView.bottomAnchor.constraint(equalTo: qrContainer.bottomAnchor, constant: -Constants.Layout.padding),
            
            // Address container constraints
            addressTitleLabel.topAnchor.constraint(equalTo: addressContainer.topAnchor, constant: Constants.Layout.padding),
            addressTitleLabel.leadingAnchor.constraint(equalTo: addressContainer.leadingAnchor, constant: Constants.Layout.padding),
            addressTitleLabel.trailingAnchor.constraint(equalTo: addressContainer.trailingAnchor, constant: -Constants.Layout.padding),
            
            addressLabel.topAnchor.constraint(equalTo: addressTitleLabel.bottomAnchor, constant: 12),
            addressLabel.leadingAnchor.constraint(equalTo: addressContainer.leadingAnchor, constant: Constants.Layout.padding),
            addressLabel.trailingAnchor.constraint(equalTo: addressContainer.trailingAnchor, constant: -Constants.Layout.padding),
            addressLabel.bottomAnchor.constraint(equalTo: addressContainer.bottomAnchor, constant: -Constants.Layout.padding)
        ])
    }
    
    private func setupConstraints() {
        let qrContainer = contentView.subviews[0]
        let addressContainer = contentView.subviews[1]
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // QR container
            qrContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            qrContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            qrContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Address container
            addressContainer.topAnchor.constraint(equalTo: qrContainer.bottomAnchor, constant: 20),
            addressContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            addressContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Copy button
            copyButton.topAnchor.constraint(equalTo: addressContainer.bottomAnchor, constant: 30),
            copyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            copyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            copyButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Share button
            shareButton.topAnchor.constraint(equalTo: copyButton.bottomAnchor, constant: 12),
            shareButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            shareButton.heightAnchor.constraint(equalToConstant: 56),
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func generateQRCode() {
        let data = walletAddress.data(using: .utf8)!
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                qrCodeImageView.image = UIImage(ciImage: output)
            }
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func copyAddress() {
        UIPasteboard.general.string = walletAddress
        
        HapticManager.shared.notification(.success)
        
        // Show success feedback
        let originalTitle = copyButton.titleLabel?.text
        copyButton.setTitle("Copied! ✓", for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.copyButton.setTitle(originalTitle, for: .normal)
        }
    }
    
    @objc private func shareAddress() {
        HapticManager.shared.impact(.light)
        
        let activityViewController = UIActivityViewController(
            activityItems: [walletAddress],
            applicationActivities: nil
        )
        
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityViewController, animated: true)
    }
}
