//
//  GradientButton.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

class GradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        gradientLayer.colors = [
            Constants.Colors.gradientStart.cgColor,
            Constants.Colors.gradientEnd.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = Constants.Layout.cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = Constants.Layout.cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        
        setTitleColor(.white, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.6), for: .disabled)
        titleLabel?.font = Constants.Fonts.title3
        
        // Setup loading indicator
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func updateLoadingState() {
        if isLoading {
            titleLabel?.alpha = 0
            loadingIndicator.startAnimating()
            isEnabled = false
        } else {
            titleLabel?.alpha = 1
            loadingIndicator.stopAnimating()
            isEnabled = true
        }
    }
    
    @objc private func buttonPressed() {
        guard !isLoading else { return }
        
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            self.alpha = 0.9
        }
        HapticManager.shared.impact(.light)
    }
    
    @objc private func buttonReleased() {
        guard !isLoading else { return }
        
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}
