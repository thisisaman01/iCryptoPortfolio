//
//  AssetDetailHeaderView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

class AssetDetailHeaderView: CardView {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    private let holdingsLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Setup all subviews with constraints
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 25
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        nameLabel.font = Constants.Fonts.title2
        nameLabel.textColor = Constants.Colors.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        symbolLabel.font = Constants.Fonts.body
        symbolLabel.textColor = Constants.Colors.textSecondary
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolLabel)
        
        priceLabel.font = Constants.Fonts.title1
        priceLabel.textColor = Constants.Colors.textPrimary
        priceLabel.textAlignment = .right
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceLabel)
        
        changeLabel.font = Constants.Fonts.body
        changeLabel.textAlignment = .right
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(changeLabel)
        
        holdingsLabel.font = Constants.Fonts.subheadline
        holdingsLabel.textColor = Constants.Colors.textSecondary
        holdingsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(holdingsLabel)
        
        valueLabel.font = Constants.Fonts.title3
        valueLabel.textColor = Constants.Colors.textPrimary
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.padding),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.padding),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.padding),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 8),
            
            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            changeLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            
            holdingsLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            holdingsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            
            valueLabel.topAnchor.constraint(equalTo: holdingsLabel.topAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Layout.padding)
        ])
    }
    
    func configure(with asset: Asset) {
        nameLabel.text = asset.name
        symbolLabel.text = asset.symbol
        priceLabel.text = asset.formattedPrice
        changeLabel.text = asset.formattedChange
        changeLabel.textColor = asset.isPositive ? Constants.Colors.greenPositive : Constants.Colors.redNegative
        holdingsLabel.text = "Holdings: \(asset.formattedHoldings) \(asset.symbol)"
        valueLabel.text = asset.formattedTotalValue
        
        // Set icon
        iconImageView.backgroundColor = getAssetColor(for: asset.symbol)
        let label = UILabel()
        label.text = String(asset.symbol.prefix(1))
        label.textColor = .white
        label.font = Constants.Fonts.title2
        label.textAlignment = .center
        label.frame = iconImageView.bounds
        iconImageView.addSubview(label)
    }
    
    private func getAssetColor(for symbol: String) -> UIColor {
        switch symbol {
        case "BTC": return UIColor.systemOrange
        case "ETH": return UIColor.systemBlue
        case "LTC": return UIColor.systemGray
        default: return Constants.Colors.primaryBlue
        }
    }
}
