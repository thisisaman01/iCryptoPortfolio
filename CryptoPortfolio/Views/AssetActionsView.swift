//
//  AssetActionsView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class AssetActionsView: UIView {
    private let buyButton = GradientButton()
    private let sellButton = UIButton(type: .system)
    
    var onBuyTapped: (() -> Void)?
    var onSellTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        buyButton.setTitle("Buy More", for: .normal)
        buyButton.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buyButton)
        
        sellButton.setTitle("Sell", for: .normal)
        sellButton.setTitleColor(Constants.Colors.redNegative, for: .normal)
        sellButton.titleLabel?.font = Constants.Fonts.title3
        sellButton.backgroundColor = Constants.Colors.cardBackground
        sellButton.layer.cornerRadius = Constants.Layout.cornerRadius
        sellButton.layer.borderWidth = 1
        sellButton.layer.borderColor = Constants.Colors.redNegative.cgColor
        sellButton.addTarget(self, action: #selector(sellTapped), for: .touchUpInside)
        sellButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sellButton)
        
        NSLayoutConstraint.activate([
            buyButton.topAnchor.constraint(equalTo: topAnchor),
            buyButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            buyButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -6),
            buyButton.heightAnchor.constraint(equalToConstant: 56),
            buyButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            sellButton.topAnchor.constraint(equalTo: topAnchor),
            sellButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 6),
            sellButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            sellButton.heightAnchor.constraint(equalToConstant: 56),
            sellButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func buyTapped() {
        onBuyTapped?()
    }
    
    @objc private func sellTapped() {
        onSellTapped?()
    }
}
