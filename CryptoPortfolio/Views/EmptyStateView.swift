//
//  EmptyStateView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

class EmptyStateView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = GradientButton()
    
    private var buttonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmptyState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmptyState()
    }
    
    private func setupEmptyState() {
        // Image
        imageView.tintColor = Constants.Colors.textSecondary.withAlphaComponent(0.6)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        // Title
        titleLabel.font = Constants.Fonts.title2
        titleLabel.textColor = Constants.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.font = Constants.Fonts.body
        subtitleLabel.textColor = Constants.Colors.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        
        // Action button
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        
        setupConstraints()
        
        // Add theme change observer
        ThemeManager.shared.addDelegate(self)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            actionButton.heightAnchor.constraint(equalToConstant: 48),
            actionButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -40)
        ])
    }
    
    func configure(image: String, title: String, subtitle: String, buttonTitle: String?, action: (() -> Void)? = nil) {
        imageView.image = UIImage(systemName: image)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        if let buttonTitle = buttonTitle {
            actionButton.setTitle(buttonTitle, for: .normal)
            actionButton.isHidden = false
            buttonAction = action
        } else {
            actionButton.isHidden = true
            buttonAction = nil
        }
    }
    
    @objc private func actionButtonTapped() {
        buttonAction?()
    }
    
    deinit {
        ThemeManager.shared.removeDelegate(self)
    }
}

extension EmptyStateView: ThemeManagerDelegate {
    func themeDidChange() {
        titleLabel.textColor = Constants.Colors.textPrimary
        subtitleLabel.textColor = Constants.Colors.textSecondary
        imageView.tintColor = Constants.Colors.textSecondary.withAlphaComponent(0.6)
    }
}

