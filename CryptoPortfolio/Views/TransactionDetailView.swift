//
//  TransactionDetailView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

class TransactionDetailView: CardView {
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Layout.padding)
        ])
    }
    
    func configure(with transaction: Transaction) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let titleLabel = UILabel()
        titleLabel.text = "Transaction Details"
        titleLabel.font = Constants.Fonts.title3
        titleLabel.textColor = Constants.Colors.textPrimary
        stackView.addArrangedSubview(titleLabel)
        
        addDetailRow(title: "Transaction ID", value: transaction.id)
        
        if let hash = transaction.hash {
            addDetailRow(title: "Hash", value: hash, isCopyable: true)
        }
        
        if let fee = transaction.fee {
            addDetailRow(title: "Network Fee", value: "\(String(format: "%.6f", fee)) \(transaction.currency)")
        }
        
        if let toAddress = transaction.toAddress {
            addDetailRow(title: "To Address", value: toAddress, isCopyable: true)
        }
        
        if let fromAddress = transaction.fromAddress {
            addDetailRow(title: "From Address", value: fromAddress, isCopyable: true)
        }
        
        addDetailRow(title: "Date", value: transaction.formattedDateTime)
        addDetailRow(title: "Status", value: transaction.status.rawValue)
    }
    
    private func addDetailRow(title: String, value: String, isCopyable: Bool = false) {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Constants.Fonts.subheadline
        titleLabel.textColor = Constants.Colors.textSecondary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Constants.Fonts.body
        valueLabel.textColor = Constants.Colors.textPrimary
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        if isCopyable {
            let copyButton = UIButton(type: .system)
            copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
            copyButton.tintColor = Constants.Colors.primaryBlue
            copyButton.addTarget(self, action: #selector(copyValue(_:)), for: .touchUpInside)
            copyButton.tag = stackView.arrangedSubviews.count
            copyButton.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(copyButton)
            
            NSLayoutConstraint.activate([
                copyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                copyButton.topAnchor.constraint(equalTo: valueLabel.topAnchor),
                copyButton.widthAnchor.constraint(equalToConstant: 32),
                copyButton.heightAnchor.constraint(equalToConstant: 32),
                
                valueLabel.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -8)
            ])
        } else {
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Store value for copying
        containerView.accessibilityValue = value
        
        stackView.addArrangedSubview(containerView)
    }
    
    @objc private func copyValue(_ sender: UIButton) {
        if let containerView = sender.superview,
           let value = containerView.accessibilityValue {
            UIPasteboard.general.string = value
            HapticManager.shared.notification(.success)
            
            // Show visual feedback
            let originalImage = sender.image(for: .normal)
            sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sender.setImage(originalImage, for: .normal)
            }
        }
    }
}
