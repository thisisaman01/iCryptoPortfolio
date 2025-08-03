//
//  TransactionTableViewCell.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class TransactionTableViewCell: UITableViewCell {
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let amountLabel = UILabel()
    private let currencyLabel = UILabel()
    private let statusLabel = UILabel()
    
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
        
        // Icon container
        iconContainerView.layer.cornerRadius = 20
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconContainerView)
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconImageView)
        
        // Title
        titleLabel.font = Constants.Fonts.body
        titleLabel.textColor = Constants.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Date
        dateLabel.font = Constants.Fonts.caption
        dateLabel.textColor = Constants.Colors.textSecondary
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        // Status
        statusLabel.font = Constants.Fonts.caption2
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusLabel)
        
        // Amount
        amountLabel.font = Constants.Fonts.body
        amountLabel.textAlignment = .right
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(amountLabel)
        
        // Currency
        currencyLabel.font = Constants.Fonts.caption
        currencyLabel.textColor = Constants.Colors.textSecondary
        currencyLabel.textAlignment = .right
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(currencyLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Icon container
            iconContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            iconContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 40),
            iconContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            // Date
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            // Status
            statusLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8),
            statusLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            statusLabel.widthAnchor.constraint(equalToConstant: 60),
            statusLabel.heightAnchor.constraint(equalToConstant: 16),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Amount
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            
            // Currency
            currencyLabel.trailingAnchor.constraint(equalTo: amountLabel.trailingAnchor),
            currencyLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            currencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with transaction: Transaction) {
        titleLabel.text = transaction.type.rawValue
        dateLabel.text = transaction.formattedDate
        amountLabel.text = transaction.formattedAmount
        currencyLabel.text = transaction.currency
        
        iconContainerView.backgroundColor = transaction.type.color
        iconImageView.image = UIImage(systemName: transaction.type.icon)
        
        amountLabel.textColor = transaction.type == .receive ? Constants.Colors.greenPositive : Constants.Colors.textPrimary
        
        // Configure status
        statusLabel.text = transaction.status.rawValue
        statusLabel.backgroundColor = transaction.status.color.withAlphaComponent(0.2)
        statusLabel.textColor = transaction.status.color
    }
}
