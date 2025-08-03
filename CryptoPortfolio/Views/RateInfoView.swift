//
//  RateInfoView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

// MARK: - Enhanced Rate Info View
class RateInfoView: CardView {
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
    
    func configure(with rate: ExchangeRate) {
        // Clear existing views
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        addInfoRow(title: "Rate", value: rate.formattedRate, icon: "chart.line.uptrend.xyaxis")
        addInfoRow(title: "Spread", value: rate.formattedSpread, icon: "percent")
        addInfoRow(title: "Gas fee", value: rate.formattedGasFee, icon: "fuelpump")
        
        // Add separator
        let separator = UIView()
        separator.backgroundColor = Constants.Colors.textSecondary.withAlphaComponent(0.3)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(separator)
        
        addInfoRow(title: "You will receive", value: "₹1,75,716.07", icon: "arrow.down.circle", isHighlighted: true)
    }
    
    private func addInfoRow(title: String, value: String, icon: String, isHighlighted: Bool = false) {
        let containerView = UIView()
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = isHighlighted ? Constants.Colors.primaryBlue : Constants.Colors.textSecondary
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = isHighlighted ? Constants.Fonts.callout : Constants.Fonts.body
        titleLabel.textColor = isHighlighted ? Constants.Colors.textPrimary : Constants.Colors.textSecondary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = isHighlighted ? Constants.Fonts.title3 : Constants.Fonts.body
        valueLabel.textColor = Constants.Colors.textPrimary
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if isHighlighted {
            containerView.backgroundColor = Constants.Colors.primaryBlue.withAlphaComponent(0.1)
            containerView.layer.cornerRadius = Constants.Layout.smallCornerRadius
        }
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: isHighlighted ? 12 : 0),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: isHighlighted ? -12 : 0),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            
            containerView.heightAnchor.constraint(equalToConstant: isHighlighted ? 48 : 32)
        ])
        
        stackView.addArrangedSubview(containerView)
    }
}
