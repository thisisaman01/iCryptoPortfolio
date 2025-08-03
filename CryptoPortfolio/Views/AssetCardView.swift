//
//  AssetCardView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class AssetCardView: CardView {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    private let holdingsLabel = UILabel()
    private let totalValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAssetCard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAssetCard()
    }
    
    private func setupAssetCard() {
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Name
        nameLabel.font = Constants.Fonts.callout
        nameLabel.textColor = Constants.Colors.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        // Symbol
        symbolLabel.font = Constants.Fonts.subheadline
        symbolLabel.textColor = Constants.Colors.textSecondary
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolLabel)
        
        // Price
        priceLabel.font = Constants.Fonts.callout
        priceLabel.textColor = Constants.Colors.textPrimary
        priceLabel.textAlignment = .right
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceLabel)
        
        // Change
        changeLabel.font = Constants.Fonts.subheadline
        changeLabel.textAlignment = .right
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(changeLabel)
        
        // Holdings
        holdingsLabel.font = Constants.Fonts.caption2
        holdingsLabel.textColor = Constants.Colors.textSecondary
        holdingsLabel.textAlignment = .right
        holdingsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(holdingsLabel)
        
        // Total value
        totalValueLabel.font = Constants.Fonts.caption2
        totalValueLabel.textColor = Constants.Colors.textSecondary
        totalValueLabel.textAlignment = .right
        totalValueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalValueLabel)
        
        setupConstraints()
        
        // Add subtle hover effect
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Icon
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.padding),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Name
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            // Symbol
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            // Price
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.padding),
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 8),
            
            // Change
            changeLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            changeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: symbolLabel.trailingAnchor, constant: 8),
            
            // Holdings
            holdingsLabel.trailingAnchor.constraint(equalTo: changeLabel.trailingAnchor),
            holdingsLabel.topAnchor.constraint(equalTo: changeLabel.bottomAnchor, constant: 2),
            
            // Total value
            totalValueLabel.trailingAnchor.constraint(equalTo: holdingsLabel.trailingAnchor),
            totalValueLabel.topAnchor.constraint(equalTo: holdingsLabel.bottomAnchor, constant: 2),
            totalValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with asset: Asset) {
        nameLabel.text = asset.name
        symbolLabel.text = asset.symbol
        priceLabel.text = asset.formattedPrice
        changeLabel.text = asset.formattedChange
        changeLabel.textColor = asset.isPositive ? Constants.Colors.greenPositive : Constants.Colors.redNegative
        holdingsLabel.text = "\(asset.formattedHoldings) \(asset.symbol)"
        totalValueLabel.text = asset.formattedTotalValue
        
        // Set icon with color based on cryptocurrency
        iconImageView.backgroundColor = getAssetColor(for: asset.symbol)
        iconImageView.layer.cornerRadius = 20
        
        // Add subtle text for the icon
        let label = UILabel()
        label.text = String(asset.symbol.prefix(1))
        label.textColor = .white
        label.font = Constants.Fonts.title3
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.alpha = 0.9
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}
