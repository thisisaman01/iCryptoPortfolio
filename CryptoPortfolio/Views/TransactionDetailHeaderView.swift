//
//  TransactionDetailHeaderView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

// MARK: - Transaction Detail Components
class TransactionDetailHeaderView: CardView {
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let typeLabel = UILabel()
    private let statusLabel = UILabel()
    private let amountLabel = UILabel()
    private let currencyLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Icon container
        iconContainerView.layer.cornerRadius = 30
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconContainerView)
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconImageView)
        
        // Type
        typeLabel.font = Constants.Fonts.title2
        typeLabel.textColor = Constants.Colors.textPrimary
        typeLabel.textAlignment = .center
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(typeLabel)
        
        // Status
        statusLabel.font = Constants.Fonts.body
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 12
        statusLabel.layer.masksToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statusLabel)
        
        // Amount
        amountLabel.font = Constants.Fonts.largeTitle
        amountLabel.textColor = Constants.Colors.textPrimary
        amountLabel.textAlignment = .center
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(amountLabel)
        
        // Currency
        currencyLabel.font = Constants.Fonts.title3
        currencyLabel.textColor = Constants.Colors.textSecondary
        currencyLabel.textAlignment = .center
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currencyLabel)
        
        // Date
        dateLabel.font = Constants.Fonts.body
        dateLabel.textColor = Constants.Colors.textSecondary
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconContainerView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.largePadding),
            iconContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 60),
            iconContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            typeLabel.topAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: 16),
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            
            statusLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.widthAnchor.constraint(equalToConstant: 80),
            statusLabel.heightAnchor.constraint(equalToConstant: 24),
            
            amountLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            
            currencyLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            currencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            currencyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            
            dateLabel.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Layout.largePadding)
        ])
    }
    
    func configure(with transaction: Transaction) {
        typeLabel.text = transaction.type.rawValue
        statusLabel.text = transaction.status.rawValue
        statusLabel.backgroundColor = transaction.status.color.withAlphaComponent(0.2)
        statusLabel.textColor = transaction.status.color
        
        amountLabel.text = transaction.formattedAmount
        amountLabel.textColor = transaction.type == .receive ? Constants.Colors.greenPositive : Constants.Colors.textPrimary
        
        currencyLabel.text = transaction.currency
        dateLabel.text = transaction.formattedDateTime
        
        iconContainerView.backgroundColor = transaction.type.color
        iconImageView.image = UIImage(systemName: transaction.type.icon)
    }
}

