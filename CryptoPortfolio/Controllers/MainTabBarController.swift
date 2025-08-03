//
//  MainTabBarController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    private let centerButton = UIButton(type: .system)
    private var customTabBarContainer: UIView!
    private var floatingTabBar: FloatingPillTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        hideDefaultTabBar()
        setupFloatingPillTabBar()
        setupFloatingCenterButton()
        
        ThemeManager.shared.addDelegate(self)
    }
    
    private func hideDefaultTabBar() {
        tabBar.isHidden = true
    }
    
    private func setupViewControllers() {
        let portfolioVC = PortfolioViewController()
        let portfolioNav = createNavigationController(
            rootViewController: portfolioVC,
            title: "Analytics",
            image: "chart.line.uptrend.xyaxis"
        )
        
        let exchangeVC = ExchangeViewController()
        let exchangeNav = createNavigationController(
            rootViewController: exchangeVC,
            title: "Exchange",
            image: "arrow.2.circlepath"
        )
        
        let transactionsVC = TransactionsViewController()
        let transactionsNav = createNavigationController(
            rootViewController: transactionsVC,
            title: "Record",
            image: "list.bullet.rectangle"
        )
        
        let walletVC = WalletViewController()
        let walletNav = createNavigationController(
            rootViewController: walletVC,
            title: "Wallet",
            image: "creditcard"
        )
        
        viewControllers = [portfolioNav, exchangeNav, transactionsNav, walletNav]
        selectedIndex = 0
    }
    
    private func createNavigationController(
        rootViewController: UIViewController,
        title: String,
        image: String
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.isHidden = true
        return navController
    }
    
    private func setupFloatingPillTabBar() {
        customTabBarContainer = UIView()
        customTabBarContainer.backgroundColor = .clear
        view.addSubview(customTabBarContainer)
        
        floatingTabBar = FloatingPillTabBar()
        floatingTabBar.delegate = self
        customTabBarContainer.addSubview(floatingTabBar)
        
        // Setup tab items
        let tabItems = [
            TabBarItemData(title: "Analytics", iconName: "chart.line.uptrend.xyaxis"),
            TabBarItemData(title: "Exchange", iconName: "arrow.2.circlepath"),
            TabBarItemData(title: "Record", iconName: "list.bullet.rectangle"),
            TabBarItemData(title: "Wallet", iconName: "creditcard")
        ]
        
        floatingTabBar.setupTabItems(tabItems)
        floatingTabBar.selectTab(at: 0)
    }
    
    private func setupFloatingCenterButton() {
        // 🎯 BUTTON SIZE REFERENCE - Change these values to adjust + button size
        let buttonSize: CGFloat = 70
        let buttonRadius = buttonSize / 2
        
        centerButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        centerButton.backgroundColor = .white
        centerButton.layer.cornerRadius = buttonRadius
        
        // Perfect floating shadow
        centerButton.layer.shadowColor = UIColor.black.cgColor
        centerButton.layer.shadowOpacity = 0.25
        centerButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        centerButton.layer.shadowRadius = 12
        
        // Blue plus icon exactly like Figma
        let iconSize: CGFloat = 20
        centerButton.setImage(
            UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: iconSize, weight: .bold)),
            for: .normal
        )
        centerButton.tintColor = Constants.Colors.primaryBlue
        
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        centerButton.addTarget(self, action: #selector(centerButtonPressed), for: .touchDown)
        centerButton.addTarget(self, action: #selector(centerButtonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        view.addSubview(centerButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeBottomInset = view.safeAreaInsets.bottom
        
        let tabBarHeight: CGFloat = 80
        let bottomPadding: CGFloat = 20
        let pillLeftMargin: CGFloat = 20
        let plusButtonSpace: CGFloat = 80
        
        // Position the container
        customTabBarContainer.frame = CGRect(
            x: 0,
            y: view.bounds.height - tabBarHeight - safeBottomInset - bottomPadding,
            width: view.bounds.width,
            height: tabBarHeight
        )
        
        floatingTabBar.frame = CGRect(
            x: pillLeftMargin,
            y: 0,
            width: view.bounds.width - (pillLeftMargin * 2) - plusButtonSpace,
            height: tabBarHeight
        )
        
        let buttonX = floatingTabBar.frame.maxX + (plusButtonSpace / 2)
        
        centerButton.center = CGPoint(
            x: buttonX,
            y: customTabBarContainer.frame.minY + (customTabBarContainer.frame.height / 2)
        )
    }
    
    @objc private func centerButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.centerButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func centerButtonReleased() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.centerButton.transform = .identity
        })
    }
    
    @objc private func centerButtonTapped() {
        HapticManager.shared.impact(.medium)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = centerButton
            popover.sourceRect = centerButton.bounds
        }
        
        alertController.addAction(UIAlertAction(title: "Send", style: .default, handler: { _ in
            self.presentSendViewController()
        }))
        
        alertController.addAction(UIAlertAction(title: "Receive", style: .default, handler: { _ in
            self.presentReceiveViewController()
        }))
        
        alertController.addAction(UIAlertAction(title: "Exchange", style: .default, handler: { _ in
            self.selectedIndex = 1
            self.floatingTabBar.selectTab(at: 1)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func presentSendViewController() {
        let sendVC = SendViewController()
        let navController = UINavigationController(rootViewController: sendVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    private func presentReceiveViewController() {
        let receiveVC = ReceiveViewController()
        let navController = UINavigationController(rootViewController: receiveVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    deinit {
        ThemeManager.shared.removeDelegate(self)
    }
}

// MARK: - Tab Bar Item Data

struct TabBarItemData {
    let title: String
    let iconName: String
}

// MARK: - Floating Pill Tab Bar Delegate

protocol FloatingPillTabBarDelegate: AnyObject {
    func didSelectTab(at index: Int)
}

// MARK: - 🎯 FLOATING PILL TAB BAR

class FloatingPillTabBar: UIView {
    weak var delegate: FloatingPillTabBarDelegate?
    
    internal var pillBackgroundView: UIView!
    private var blurView: UIVisualEffectView!
    private var selectedIndicator: UIView!
    private var tabButtons: [UIButton] = []
    private var tabItems: [TabBarItemData] = []
    private var selectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPillDesign()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPillDesign()
    }
    
    private func setupPillDesign() {
        backgroundColor = .clear
        
        // Create pill background
        pillBackgroundView = UIView()
        pillBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        pillBackgroundView.layer.cornerRadius = 40
        addSubview(pillBackgroundView)
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 40
        blurView.clipsToBounds = true
        pillBackgroundView.addSubview(blurView)
        
        // Add border
        pillBackgroundView.layer.borderWidth = 1
        pillBackgroundView.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        
        // Add shadow
        pillBackgroundView.layer.shadowColor = UIColor.black.cgColor
        pillBackgroundView.layer.shadowOpacity = 0.3
        pillBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 8)
        pillBackgroundView.layer.shadowRadius = 20
        
        // Create selected indicator
        selectedIndicator = UIView()
        selectedIndicator.backgroundColor = Constants.Colors.primaryBlue
        selectedIndicator.layer.cornerRadius = 24
        selectedIndicator.alpha = 0
        pillBackgroundView.addSubview(selectedIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        pillBackgroundView.frame = bounds
        blurView.frame = pillBackgroundView.bounds
        
  
        layoutTabButtons()
    }
    
    func setupTabItems(_ items: [TabBarItemData]) {
        tabItems = items
        
        tabButtons.forEach { $0.removeFromSuperview() }
        tabButtons.removeAll()
        
        for (index, item) in items.enumerated() {
            let button = createTabButton(for: item, at: index)
            tabButtons.append(button)
            pillBackgroundView.addSubview(button)
        }
        
        setNeedsLayout()
    }
    
    private func createTabButton(for item: TabBarItemData, at index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = index
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        
      
        let tabIconSize: CGFloat = 18
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: item.iconName)?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: tabIconSize, weight: .medium)
        )
        iconImageView.tintColor = UIColor.white.withAlphaComponent(0.6)
        iconImageView.contentMode = .scaleAspectFit
        
   
        let tabTextSize: CGFloat = 11
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: tabTextSize, weight: .medium)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        titleLabel.textAlignment = .center
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        
        button.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func layoutTabButtons() {
        guard !tabButtons.isEmpty else { return }
        
        let buttonWidth = bounds.width / CGFloat(tabButtons.count)
        
        for (index, button) in tabButtons.enumerated() {
            button.frame = CGRect(
                x: CGFloat(index) * buttonWidth,
                y: 0,
                width: buttonWidth,
                height: bounds.height
            )
        }
        
        updateSelectedIndicator()
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        selectTab(at: sender.tag)
        delegate?.didSelectTab(at: sender.tag)
    }
    
    func selectTab(at index: Int) {
        guard index < tabButtons.count else { return }
        
        selectedIndex = index
        
        for (i, button) in tabButtons.enumerated() {
            let isSelected = i == index
            let alpha: CGFloat = isSelected ? 1.0 : 0.6
            
            if let stackView = button.subviews.first as? UIStackView {
                stackView.arrangedSubviews.forEach { view in
                    if let imageView = view as? UIImageView {
                        imageView.tintColor = UIColor.white.withAlphaComponent(alpha)
                    } else if let label = view as? UILabel {
                        label.textColor = UIColor.white.withAlphaComponent(alpha)
                    }
                }
            }
        }
        
        updateSelectedIndicator()
    }
    
    private func updateSelectedIndicator() {
        guard selectedIndex < tabButtons.count, bounds.width > 0 else { return }
        

        let indicatorWidth: CGFloat = 56
        let indicatorHeight: CGFloat = 46
        let indicatorRadius = indicatorHeight / 2
        
        let buttonWidth = bounds.width / CGFloat(tabButtons.count)
        let buttonCenterX = (CGFloat(selectedIndex) * buttonWidth) + (buttonWidth / 2)
        
        let targetX = buttonCenterX - (indicatorWidth / 2)
        let targetY = (bounds.height - indicatorHeight) / 2
        
        selectedIndicator.backgroundColor = Constants.Colors.primaryBlue
        selectedIndicator.layer.cornerRadius = indicatorRadius
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.selectedIndicator.frame = CGRect(
                x: targetX,
                y: targetY,
                width: indicatorWidth,
                height: indicatorHeight
            )
            self.selectedIndicator.alpha = 1
        })
    }
}

// MARK: - Floating Tab Bar Delegate

extension MainTabBarController: FloatingPillTabBarDelegate {
    func didSelectTab(at index: Int) {
        selectedIndex = index
    }
}

// MARK: - Theme Support

extension MainTabBarController: ThemeManagerDelegate {
    func themeDidChange() {
        // Update colors while maintaining Figma design
        floatingTabBar?.pillBackgroundView?.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
    }
}




// MARK: - GUIDE
/*

 
 🔹 PLUS BUTTON SIZE:
    • Line 136: let buttonSize: CGFloat = 64
    • Line 148: let iconSize: CGFloat = 20
 
 🔹 BLUE SELECTION BUBBLE:
    • Line 342: let indicatorWidth: CGFloat = 80
    • Line 343: let indicatorHeight: CGFloat = 48
 
 🔹 TAB BAR PILL SIZE:
    • Line 84: let tabBarHeight: CGFloat = 80
    • Line 95: let plusButtonSpace: CGFloat = 80
 
 🔹 TAB ICON & TEXT SIZE:
    • Line 268: pointSize: 18 (tab icons)
    • Line 276: fontSize: 11 (tab text)
 
 🔹 SPACING & MARGINS:
    • Line 92: x: 20 (pill left margin)
    • Line 87: bottomPadding: CGFloat = 20
*/

