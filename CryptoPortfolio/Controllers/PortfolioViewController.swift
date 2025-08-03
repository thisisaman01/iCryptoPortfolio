//
//  PortfolioViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//


import Foundation
import UIKit

class PortfolioViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let portfolioHeaderView = PortfolioHeaderView()
    private let chartContainerView = CardView()
    private let chartView = LineChartView()
    private let timeFrameSelector = TimeFrameSelector()
    private let assetsStackView = UIStackView()
    private let transactionsHeaderView = UIView()
    private let transactionsTableView = UITableView()
    
    private let dataService: DataServiceProtocol = MockDataService.shared
    private var portfolio: Portfolio?
    private var assets: [Asset] = []
    private var recentTransactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadData()
        
        // Add theme change observer
        ThemeManager.shared.addDelegate(self)
        
        // Set up header actions
        portfolioHeaderView.onMenuTapped = { [weak self] in
            self?.presentMenuViewController()
        }
        
        portfolioHeaderView.onNotificationTapped = { [weak self] in
            self?.presentNotificationsViewController()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .automatic
        scrollView.keyboardDismissMode = .onDrag
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Portfolio header
        portfolioHeaderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(portfolioHeaderView)
        
        // Chart container
        chartContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chartContainerView)
        
        // Chart view
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.addSubview(chartView)
        
        // Time frame selector
        timeFrameSelector.translatesAutoresizingMaskIntoConstraints = false
        timeFrameSelector.onSelectionChange = { [weak self] timeFrame in
            self?.loadChartData(timeFrame: timeFrame)
        }
        chartContainerView.addSubview(timeFrameSelector)
        
        // Assets stack view
        assetsStackView.axis = .vertical
        assetsStackView.spacing = 12
        assetsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(assetsStackView)
        
        // Transactions header
        setupTransactionsHeader()
        transactionsHeaderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(transactionsHeaderView)
        
        // Transactions table view
        transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.backgroundColor = .clear
        transactionsTableView.separatorStyle = .none
        transactionsTableView.isScrollEnabled = false
        transactionsTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        contentView.addSubview(transactionsTableView)
    }
    
    private func setupTransactionsHeader() {
        let titleLabel = UILabel()
        titleLabel.text = "Recent Transactions"
        titleLabel.font = Constants.Fonts.title2
        titleLabel.textColor = Constants.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let seeAllButton = UIButton(type: .system)
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.titleLabel?.font = Constants.Fonts.body
        seeAllButton.setTitleColor(Constants.Colors.primaryBlue, for: .normal)
        seeAllButton.addTarget(self, action: #selector(seeAllTransactionsTapped), for: .touchUpInside)
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        transactionsHeaderView.addSubview(titleLabel)
        transactionsHeaderView.addSubview(seeAllButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: transactionsHeaderView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: transactionsHeaderView.centerYAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: transactionsHeaderView.trailingAnchor),
            seeAllButton.centerYAnchor.constraint(equalTo: transactionsHeaderView.centerYAnchor),
            
            transactionsHeaderView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Portfolio header
            portfolioHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Layout.padding),
            portfolioHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            portfolioHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Chart container
            chartContainerView.topAnchor.constraint(equalTo: portfolioHeaderView.bottomAnchor, constant: 20),
            chartContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            chartContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            chartContainerView.heightAnchor.constraint(equalToConstant: Constants.Layout.chartHeight),
            
            // Chart view
            chartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor, constant: Constants.Layout.padding),
            chartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: Constants.Layout.padding),
            chartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor, constant: -Constants.Layout.padding),
            chartView.heightAnchor.constraint(equalToConstant: 120),
            
            // Time frame selector
            timeFrameSelector.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 12),
            timeFrameSelector.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: Constants.Layout.padding),
            timeFrameSelector.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor, constant: -Constants.Layout.padding),
            timeFrameSelector.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -Constants.Layout.padding),
            
            // Assets stack view
            assetsStackView.topAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: 20),
            assetsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            assetsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Transactions header
            transactionsHeaderView.topAnchor.constraint(equalTo: assetsStackView.bottomAnchor, constant: 20),
            transactionsHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            transactionsHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Transactions table view
            transactionsTableView.topAnchor.constraint(equalTo: transactionsHeaderView.bottomAnchor, constant: 8),
            transactionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            transactionsTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func loadData() {
        // Load portfolio data
        dataService.getPortfolio { [weak self] portfolio in
            self?.portfolio = portfolio
            self?.portfolioHeaderView.configure(with: portfolio)
        }
        
        // Load assets
        dataService.getAssets { [weak self] assets in
            self?.assets = assets
            self?.updateAssetsView()
        }
        
        // Load recent transactions
        dataService.getTransactions { [weak self] transactions in
            self?.recentTransactions = Array(transactions.prefix(5))
            self?.transactionsTableView.reloadData()
        }
        
        // Load initial chart data
        loadChartData(timeFrame: "1d")
    }
    
    private func loadChartData(timeFrame: String) {
        dataService.getChartData(timeframe: timeFrame) { [weak self] dataPoints in
            self?.chartView.updateData(dataPoints)
        }
    }
    
    private func updateAssetsView() {
        assetsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add asset cards
        for asset in assets {
            let assetCard = AssetCardView()
            assetCard.configure(with: asset)
            assetCard.heightAnchor.constraint(equalToConstant: Constants.Layout.cardHeight).isActive = true
            
            // Add tap gesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(assetCardTapped(_:)))
            assetCard.addGestureRecognizer(tapGesture)
            assetCard.isUserInteractionEnabled = true
            
            assetsStackView.addArrangedSubview(assetCard)
        }
    }
    
    private func presentMenuViewController() {
        HapticManager.shared.impact(.light)
        
        let menuVC = MenuViewController()
        menuVC.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = menuVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.preferredCornerRadius = Constants.Layout.largeCornerRadius
            }
        }
        
        present(menuVC, animated: true)
    }
    
    private func presentNotificationsViewController() {
        HapticManager.shared.impact(.light)
        
        let notificationsVC = NotificationsViewController()
        let navController = UINavigationController(rootViewController: notificationsVC)
        navController.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = navController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.preferredCornerRadius = Constants.Layout.largeCornerRadius
            }
        }
        
        present(navController, animated: true)
    }
    
    @objc private func assetCardTapped(_ gesture: UITapGestureRecognizer) {
        HapticManager.shared.impact(.light)
        
        // Get the tapped asset
        if let cardView = gesture.view as? AssetCardView,
           let index = assetsStackView.arrangedSubviews.firstIndex(of: cardView),
           index < assets.count {
            let asset = assets[index]
            
            // Present asset detail view
            let assetDetailVC = AssetDetailViewController(asset: asset)
            let navController = UINavigationController(rootViewController: assetDetailVC)
            navController.modalPresentationStyle = .pageSheet
            present(navController, animated: true)
        }
    }
    
    @objc private func seeAllTransactionsTapped() {
        HapticManager.shared.impact(.light)
        // Navigate to transactions tab
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
    
    deinit {
        ThemeManager.shared.removeDelegate(self)
    }
}

// MARK: - Portfolio View Controller Extensions
extension PortfolioViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        cell.configure(with: recentTransactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticManager.shared.impact(.light)
        
        let transaction = recentTransactions[indexPath.row]
        let transactionDetailVC = TransactionDetailViewController(transaction: transaction)
        let navController = UINavigationController(rootViewController: transactionDetailVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
}

extension PortfolioViewController: ThemeManagerDelegate {
    func themeDidChange() {
        view.backgroundColor = Constants.Colors.backgroundColor
        
        transactionsTableView.reloadData()
    }
}
