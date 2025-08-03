//
//  CurrencySelectionView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

class CurrencySelectionView: UIView {
    private let currencyButton = UIButton(type: .system)
    private let actionLabel = UILabel()
    let amountTextField = UITextField()
    private let balanceLabel = UILabel()
    
    var isFromCurrency = true
    var onAmountChanged: ((String) -> Void)?
    
    var symbol: String = ""
    var name: String = ""
    var amount: String = ""
    var balance: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = Constants.Colors.cardBackground
        layer.cornerRadius = Constants.Layout.cornerRadius
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        
        // Currency button
        currencyButton.translatesAutoresizingMaskIntoConstraints = false
        currencyButton.backgroundColor = .clear
        currencyButton.setTitleColor(Constants.Colors.textPrimary, for: .normal)
        currencyButton.titleLabel?.font = Constants.Fonts.title3
        currencyButton.contentHorizontalAlignment = .left
        currencyButton.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        addSubview(currencyButton)
        
        // Action label
        actionLabel.font = Constants.Fonts.footnote
        actionLabel.textColor = Constants.Colors.textSecondary
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionLabel)
        
        // Amount text field
        amountTextField.font = Constants.Fonts.title2
        amountTextField.textColor = Constants.Colors.textPrimary
        amountTextField.textAlignment = .right
        amountTextField.borderStyle = .none
        amountTextField.keyboardType = .decimalPad
        amountTextField.placeholder = "0.00"
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(amountTextField)
        
        // Balance label
        balanceLabel.font = Constants.Fonts.footnote
        balanceLabel.textColor = Constants.Colors.textSecondary
        balanceLabel.textAlignment = .right
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(balanceLabel)
        
        // Add toolbar to text field for dismissing keyboard
        setupKeyboardToolbar()
        
        setupConstraints()
    }
    
    private func setupKeyboardToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.items = [flexSpace, doneButton]
        amountTextField.inputAccessoryView = toolbar
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Currency button
            currencyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            currencyButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.padding),
            currencyButton.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            
            // Action label
            actionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            actionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.padding),
            
            // Amount text field
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            amountTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            amountTextField.leadingAnchor.constraint(greaterThanOrEqualTo: currencyButton.trailingAnchor, constant: 8),
            amountTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Balance label
            balanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            balanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Layout.padding)
        ])
    }
    
    func configure(symbol: String, name: String, amount: String, balance: String) {
        self.symbol = symbol
        self.name = name
        self.amount = amount
        self.balance = balance
        
        currencyButton.setTitle("\(symbol) ▼", for: .normal)
        amountTextField.text = amount
        balanceLabel.text = "Balance: \(balance)"
        actionLabel.text = isFromCurrency ? "Send" : "Receive"
    }
    
    func setAmount(_ amount: String) {
        self.amount = amount
        amountTextField.text = amount
    }
    
    @objc private func currencyButtonTapped() {
        HapticManager.shared.impact(.light)
        
        // Present currency selection modal
        let currencySelectionVC = CurrencySelectionViewController()
        currencySelectionVC.onCurrencySelected = { [weak self] selectedCurrency in
            self?.updateCurrency(selectedCurrency)
        }
        
        if let viewController = self.findViewController() {
            let navController = UINavigationController(rootViewController: currencySelectionVC)
            navController.modalPresentationStyle = .pageSheet
            viewController.present(navController, animated: true)
        }
    }
    
    @objc private func amountChanged() {
        amount = amountTextField.text ?? ""
        onAmountChanged?(amount)
    }
    
    @objc private func dismissKeyboard() {
        amountTextField.resignFirstResponder()
    }
    
    private func updateCurrency(_ currency: Currency) {
        symbol = currency.symbol
        name = currency.name
        configure(symbol: symbol, name: name, amount: amount, balance: balance)
    }
}

extension CurrencySelectionView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only numbers and decimal point
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        
        // Check if the replacement string contains only allowed characters
        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }
        
        // Get the current text
        let currentText = textField.text ?? ""
        
        // Create the new text with the replacement
        guard let textRange = Range(range, in: currentText) else {
            return false
        }
        let newText = currentText.replacingCharacters(in: textRange, with: string)
        
        // Don't allow multiple decimal points
        let decimalCount = newText.components(separatedBy: ".").count - 1
        if decimalCount > 1 {
            return false
        }
        
        // Limit to reasonable number of characters
        return newText.count <= 15
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Highlight the field when editing begins
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = Constants.Colors.primaryBlue.cgColor
            self.layer.borderWidth = 2
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Remove highlight when editing ends
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = UIColor.systemGray5.cgColor
            self.layer.borderWidth = 1
        }
    }
}
