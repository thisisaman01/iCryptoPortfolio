//
//  SendViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

// MARK: - Send View Controller
class SendViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let recipientField = UITextField()
    private let amountField = UITextField()
    private let currencySelector = UIButton()
    private let feeLabel = UILabel()
    private let sendButton = GradientButton()
    
    private let dataService: DataServiceProtocol = MockDataService.shared
    private var selectedCurrency = "BTC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupKeyboardHandling()
    }
    
    private func setupViews() {
        title = "Send Crypto"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        // Setup scroll view
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Recipient field
        let recipientCard = CardView()
        recipientCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipientCard)
        
        let recipientTitleLabel = UILabel()
        recipientTitleLabel.text = "Recipient Address"
        recipientTitleLabel.font = Constants.Fonts.subheadline
        recipientTitleLabel.textColor = Constants.Colors.textSecondary
        recipientTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recipientCard.addSubview(recipientTitleLabel)
        
        recipientField.placeholder = "Enter wallet address"
        recipientField.font = Constants.Fonts.body
        recipientField.textColor = Constants.Colors.textPrimary
        recipientField.borderStyle = .none
        recipientField.autocapitalizationType = .none
        recipientField.autocorrectionType = .no
        recipientField.translatesAutoresizingMaskIntoConstraints = false
        recipientCard.addSubview(recipientField)
        
        let scanButton = UIButton(type: .system)
        scanButton.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
        scanButton.tintColor = Constants.Colors.primaryBlue
        scanButton.addTarget(self, action: #selector(scanQRCode), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        recipientCard.addSubview(scanButton)
        
        // Amount field
        let amountCard = CardView()
        amountCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(amountCard)
        
        let amountTitleLabel = UILabel()
        amountTitleLabel.text = "Amount"
        amountTitleLabel.font = Constants.Fonts.subheadline
        amountTitleLabel.textColor = Constants.Colors.textSecondary
        amountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        amountCard.addSubview(amountTitleLabel)
        
        amountField.placeholder = "0.00"
        amountField.font = Constants.Fonts.title2
        amountField.textColor = Constants.Colors.textPrimary
        amountField.borderStyle = .none
        amountField.keyboardType = .decimalPad
        amountField.textAlignment = .right
        amountField.translatesAutoresizingMaskIntoConstraints = false
        amountCard.addSubview(amountField)
        
        currencySelector.setTitle("BTC ▼", for: .normal)
        currencySelector.setTitleColor(Constants.Colors.primaryBlue, for: .normal)
        currencySelector.titleLabel?.font = Constants.Fonts.body
        currencySelector.addTarget(self, action: #selector(selectCurrency), for: .touchUpInside)
        currencySelector.translatesAutoresizingMaskIntoConstraints = false
        amountCard.addSubview(currencySelector)
        
        // Fee information
        let feeCard = CardView()
        feeCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(feeCard)
        
        let feeTitleLabel = UILabel()
        feeTitleLabel.text = "Network Fee"
        feeTitleLabel.font = Constants.Fonts.subheadline
        feeTitleLabel.textColor = Constants.Colors.textSecondary
        feeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        feeCard.addSubview(feeTitleLabel)
        
        feeLabel.text = "₹422.73"
        feeLabel.font = Constants.Fonts.body
        feeLabel.textColor = Constants.Colors.textPrimary
        feeLabel.textAlignment = .right
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        feeCard.addSubview(feeLabel)
        
        // Send button
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sendButton)
        
        // Setup constraints for card contents
        NSLayoutConstraint.activate([
            // Recipient card constraints
            recipientTitleLabel.topAnchor.constraint(equalTo: recipientCard.topAnchor, constant: Constants.Layout.padding),
            recipientTitleLabel.leadingAnchor.constraint(equalTo: recipientCard.leadingAnchor, constant: Constants.Layout.padding),
            
            scanButton.topAnchor.constraint(equalTo: recipientCard.topAnchor, constant: Constants.Layout.padding),
            scanButton.trailingAnchor.constraint(equalTo: recipientCard.trailingAnchor, constant: -Constants.Layout.padding),
            scanButton.widthAnchor.constraint(equalToConstant: 32),
            scanButton.heightAnchor.constraint(equalToConstant: 32),
            
            recipientField.topAnchor.constraint(equalTo: recipientTitleLabel.bottomAnchor, constant: 8),
            recipientField.leadingAnchor.constraint(equalTo: recipientCard.leadingAnchor, constant: Constants.Layout.padding),
            recipientField.trailingAnchor.constraint(equalTo: scanButton.leadingAnchor, constant: -8),
            recipientField.bottomAnchor.constraint(equalTo: recipientCard.bottomAnchor, constant: -Constants.Layout.padding),
            recipientField.heightAnchor.constraint(equalToConstant: 40),
            
            // Amount card constraints
            amountTitleLabel.topAnchor.constraint(equalTo: amountCard.topAnchor, constant: Constants.Layout.padding),
            amountTitleLabel.leadingAnchor.constraint(equalTo: amountCard.leadingAnchor, constant: Constants.Layout.padding),
            
            currencySelector.topAnchor.constraint(equalTo: amountCard.topAnchor, constant: Constants.Layout.padding),
            currencySelector.trailingAnchor.constraint(equalTo: amountCard.trailingAnchor, constant: -Constants.Layout.padding),
            
            amountField.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor, constant: 8),
            amountField.leadingAnchor.constraint(equalTo: amountCard.leadingAnchor, constant: Constants.Layout.padding),
            amountField.trailingAnchor.constraint(equalTo: currencySelector.leadingAnchor, constant: -8),
            amountField.bottomAnchor.constraint(equalTo: amountCard.bottomAnchor, constant: -Constants.Layout.padding),
            amountField.heightAnchor.constraint(equalToConstant: 40),
            
            // Fee card constraints
            feeTitleLabel.topAnchor.constraint(equalTo: feeCard.topAnchor, constant: Constants.Layout.padding),
            feeTitleLabel.leadingAnchor.constraint(equalTo: feeCard.leadingAnchor, constant: Constants.Layout.padding),
            feeTitleLabel.bottomAnchor.constraint(equalTo: feeCard.bottomAnchor, constant: -Constants.Layout.padding),
            
            feeLabel.centerYAnchor.constraint(equalTo: feeTitleLabel.centerYAnchor),
            feeLabel.trailingAnchor.constraint(equalTo: feeCard.trailingAnchor, constant: -Constants.Layout.padding),
            feeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: feeTitleLabel.trailingAnchor, constant: 8)
        ])
    }
    
    private func setupConstraints() {
        let recipientCard = contentView.subviews[0]
        let amountCard = contentView.subviews[1]
        let feeCard = contentView.subviews[2]
        
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
            
            // Recipient card
            recipientCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            recipientCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            recipientCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Amount card
            amountCard.topAnchor.constraint(equalTo: recipientCard.bottomAnchor, constant: 20),
            amountCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            amountCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Fee card
            feeCard.topAnchor.constraint(equalTo: amountCard.bottomAnchor, constant: 20),
            feeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            feeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Send button
            sendButton.topAnchor.constraint(equalTo: feeCard.bottomAnchor, constant: 30),
            sendButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            sendButton.heightAnchor.constraint(equalToConstant: 56),
            sendButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Add toolbar to amount field
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        amountField.inputAccessoryView = toolbar
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func scanQRCode() {
        HapticManager.shared.impact(.light)
        
        // Here you would implement QR code scanning
        let alert = UIAlertController(title: "QR Scanner", message: "QR code scanning would be implemented here using AVFoundation.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func selectCurrency() {
        HapticManager.shared.impact(.light)
        
        let currencySelectionVC = CurrencySelectionViewController()
        currencySelectionVC.onCurrencySelected = { [weak self] currency in
            self?.selectedCurrency = currency.symbol
            self?.currencySelector.setTitle("\(currency.symbol) ▼", for: .normal)
        }
        
        let navController = UINavigationController(rootViewController: currencySelectionVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    @objc private func sendTapped() {
        guard let recipient = recipientField.text, !recipient.isEmpty else {
            showAlert(title: "Invalid Recipient", message: "Please enter a valid recipient address.")
            return
        }
        
        guard let amountText = amountField.text, !amountText.isEmpty, let amount = Double(amountText), amount > 0 else {
            showAlert(title: "Invalid Amount", message: "Please enter a valid amount.")
            return
        }
        
        // Show loading state
        sendButton.isLoading = true
        
        // Send transaction
        dataService.sendTransaction(to: recipient, amount: amount, currency: selectedCurrency) { [weak self] success, error in
            self?.sendButton.isLoading = false
            
            if success {
                self?.showSuccessAndDismiss()
            } else {
                let message = error?.localizedDescription ?? "Transaction failed. Please try again."
                self?.showAlert(title: "Transaction Failed", message: message)
            }
        }
    }
    
    private func showSuccessAndDismiss() {
        HapticManager.shared.notification(.success)
        
        let alert = UIAlertController(title: "Transaction Sent! 🎉", message: "Your transaction has been submitted to the network.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
