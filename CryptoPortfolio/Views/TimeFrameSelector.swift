//
//  TimeFrameSelector.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class TimeFrameSelector: UIView {
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    private let timeFrames = ["1h", "8h", "1d", "1w", "1m", "1y"]
    
    var onSelectionChange: ((String) -> Void)?
    private var selectedIndex = 2 // Default to "1d"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        setupButtons()
        
        // Add theme change observer
        ThemeManager.shared.addDelegate(self)
    }
    
    private func setupButtons() {
        buttons.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, timeFrame) in timeFrames.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(timeFrame, for: .normal)
            button.titleLabel?.font = Constants.Fonts.footnote
            button.layer.cornerRadius = Constants.Layout.smallCornerRadius
            button.tag = index
            button.addTarget(self, action: #selector(timeFrameSelected(_:)), for: .touchUpInside)
            
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        updateButtonAppearance()
    }
    
    @objc private func timeFrameSelected(_ sender: UIButton) {
        selectedIndex = sender.tag
        
        // Animate selection change
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.updateButtonAppearance()
        })
        
        onSelectionChange?(timeFrames[selectedIndex])
        HapticManager.shared.selection()
    }
    
    private func updateButtonAppearance() {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.backgroundColor = Constants.Colors.primaryBlue
                button.setTitleColor(.white, for: .normal)
                button.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(Constants.Colors.textSecondary, for: .normal)
                button.transform = .identity
            }
        }
    }
    
    deinit {
        ThemeManager.shared.removeDelegate(self)
    }
}

extension TimeFrameSelector: ThemeManagerDelegate {
    func themeDidChange() {
        updateButtonAppearance()
    }
}
