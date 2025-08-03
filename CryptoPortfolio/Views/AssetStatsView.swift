//
//  AssetStatsView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class AssetStatsView: CardView {
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
    
    func configure(with asset: Asset) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let titleLabel = UILabel()
        titleLabel.text = "Statistics"
        titleLabel.font = Constants.Fonts.title3
        titleLabel.textColor = Constants.Colors.textPrimary
        stackView.addArrangedSubview(titleLabel)
        
        addStatRow(title: "24h Change", value: asset.formattedChange, isPositive: asset.isPositive)
        addStatRow(title: "Holdings", value: "\(asset.formattedHoldings) \(asset.symbol)")
        addStatRow(title: "Total Value", value: asset.formattedTotalValue)
        addStatRow(title: "Avg. Buy Price", value: "₹\(String(format: "%.2f", asset.price * 0.95))")
    }
    
    private func addStatRow(title: String, value: String, isPositive: Bool? = nil) {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Constants.Fonts.body
        titleLabel.textColor = Constants.Colors.textSecondary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Constants.Fonts.body
        valueLabel.textColor = isPositive == true ? Constants.Colors.greenPositive :
                              isPositive == false ? Constants.Colors.redNegative : Constants.Colors.textPrimary
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            
            containerView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        stackView.addArrangedSubview(containerView)
    }
}
