//
//  PortfolioHeaderView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

class PortfolioHeaderView: UIView {
    private let titleLabel = UILabel()
    private let menuButton = UIButton(type: .system)
    private let notificationButton = UIButton(type: .system)
    private let valueCardView = CardView()
    private let currencyLabel = UILabel()
    private let valueLabel = UILabel()
    private let changeLabel = UILabel()
    private let eyeButton = UIButton(type: .system)
    
    private var isValueHidden = false
    private var currentPortfolio: Portfolio?
    
    var onMenuTapped: (() -> Void)?
    var onNotificationTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Title
        titleLabel.text = "Portfolio Value"
        titleLabel.font = Constants.Fonts.body
        titleLabel.textColor = Constants.Colors.textSecondary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Menu button
        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = Constants.Colors.textPrimary
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuButton)
        
        // Notification button
        notificationButton.setImage(UIImage(systemName: "bell"), for: .normal)
        notificationButton.tintColor = Constants.Colors.textPrimary
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notificationButton)
        
        // Value card
        valueCardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueCardView)
        
        // Setup value card gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            Constants.Colors.gradientStart.cgColor,
            Constants.Colors.gradientEnd.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = Constants.Layout.cornerRadius
        valueCardView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Currency label
        currencyLabel.text = "INR"
        currencyLabel.font = Constants.Fonts.caption
        currencyLabel.textColor = .white.withAlphaComponent(0.8)
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        valueCardView.addSubview(currencyLabel)
        
        // Value label
        valueLabel.font = Constants.Fonts.largeTitle
        valueLabel.textColor = .white
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.5
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueCardView.addSubview(valueLabel)
        
        // Change label
        changeLabel.font = Constants.Fonts.body
        changeLabel.textColor = .white.withAlphaComponent(0.9)
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        valueCardView.addSubview(changeLabel)
        
        // Eye button
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.tintColor = .white.withAlphaComponent(0.8)
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        valueCardView.addSubview(eyeButton)
        
        setupConstraints()
        
        // Update gradient frame when layout changes
        DispatchQueue.main.async {
            gradientLayer.frame = self.valueCardView.bounds
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header elements
            menuButton.topAnchor.constraint(equalTo: topAnchor),
            menuButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 32),
            menuButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor),
            
            notificationButton.topAnchor.constraint(equalTo: topAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 32),
            notificationButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Value card
            valueCardView.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 20),
            valueCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            valueCardView.heightAnchor.constraint(equalToConstant: 120),
            
            // Currency label
            currencyLabel.topAnchor.constraint(equalTo: valueCardView.topAnchor, constant: Constants.Layout.padding),
            currencyLabel.leadingAnchor.constraint(equalTo: valueCardView.leadingAnchor, constant: Constants.Layout.padding),
            
            // Eye button
            eyeButton.topAnchor.constraint(equalTo: valueCardView.topAnchor, constant: Constants.Layout.padding),
            eyeButton.trailingAnchor.constraint(equalTo: valueCardView.trailingAnchor, constant: -Constants.Layout.padding),
            eyeButton.widthAnchor.constraint(equalToConstant: 24),
            eyeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Value label
            valueLabel.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: valueCardView.leadingAnchor, constant: Constants.Layout.padding),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: eyeButton.leadingAnchor, constant: -8),
            
            // Change label
            changeLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            changeLabel.leadingAnchor.constraint(equalTo: valueCardView.leadingAnchor, constant: Constants.Layout.padding),
            changeLabel.bottomAnchor.constraint(lessThanOrEqualTo: valueCardView.bottomAnchor, constant: -Constants.Layout.padding)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient frame
        if let gradientLayer = valueCardView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = valueCardView.bounds
        }
    }
    
    func configure(with portfolio: Portfolio) {
        currentPortfolio = portfolio
        updateDisplay()
    }
    
    private func updateDisplay() {
        guard let portfolio = currentPortfolio else { return }
        
        if isValueHidden {
            valueLabel.text = "••••••••"
            changeLabel.text = "••••"
        } else {
            valueLabel.text = portfolio.formattedValue
            changeLabel.text = "\(portfolio.formattedChange) (₹\(String(format: "%.0f", portfolio.change24h)))"
        }
    }
    
    @objc private func menuButtonTapped() {
        HapticManager.shared.impact(.light)
        
        // Add button press animation
        UIView.animate(withDuration: 0.1, animations: {
            self.menuButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.menuButton.transform = .identity
            }
        }
        
        onMenuTapped?()
    }
    
    @objc private func notificationButtonTapped() {
        HapticManager.shared.impact(.light)
        
        // Add button press animation
        UIView.animate(withDuration: 0.1, animations: {
            self.notificationButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.notificationButton.transform = .identity
            }
        }
        
        onNotificationTapped?()
    }
    
    @objc private func eyeButtonTapped() {
        isValueHidden.toggle()
        eyeButton.setImage(
            UIImage(systemName: isValueHidden ? "eye.slash" : "eye"),
            for: .normal
        )
        
        // Animate the change
        UIView.transition(with: valueLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.updateDisplay()
        }
        
        UIView.transition(with: changeLabel, duration: 0.3, options: .transitionCrossDissolve) {
            // Already updated in updateDisplay()
        }
        
        HapticManager.shared.impact(.light)
    }
}
