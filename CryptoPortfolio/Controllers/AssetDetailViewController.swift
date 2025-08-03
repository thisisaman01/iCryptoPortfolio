//
//  AssetDetailViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


// MARK: - Asset Detail View Controller
class AssetDetailViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = AssetDetailHeaderView()
    private let chartView = LineChartView()
    private let timeFrameSelector = TimeFrameSelector()
    private let statsView = AssetStatsView()
    private let actionsView = AssetActionsView()
    
    private let asset: Asset
    private let dataService: DataServiceProtocol = MockDataService.shared
    
    init(asset: Asset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadData()
    }
    
    private func setupViews() {
        title = asset.name
        view.backgroundColor = Constants.Colors.backgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Header
        headerView.configure(with: asset)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        
        // Chart
        chartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chartView)
        
        // Time frame selector
        timeFrameSelector.onSelectionChange = { [weak self] timeFrame in
            self?.loadChartData(timeFrame: timeFrame)
        }
        timeFrameSelector.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeFrameSelector)
        
        // Stats
        statsView.configure(with: asset)
        statsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsView)
        
        // Actions
        actionsView.onBuyTapped = { [weak self] in
            self?.presentBuyViewController()
        }
        actionsView.onSellTapped = { [weak self] in
            self?.presentSellViewController()
        }
        actionsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actionsView)
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
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Layout.padding),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Chart
            chartView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            chartView.heightAnchor.constraint(equalToConstant: 200),
            
            // Time frame selector
            timeFrameSelector.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            timeFrameSelector.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            timeFrameSelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Stats
            statsView.topAnchor.constraint(equalTo: timeFrameSelector.bottomAnchor, constant: 20),
            statsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            statsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Actions
            actionsView.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 20),
            actionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            actionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            actionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func loadData() {
        loadChartData(timeFrame: "1d")
    }
    
    private func loadChartData(timeFrame: String) {
        dataService.getChartData(timeframe: timeFrame) { [weak self] dataPoints in
            self?.chartView.updateData(dataPoints)
        }
    }
    
    private func presentBuyViewController() {
        // Present buy interface
        HapticManager.shared.impact(.medium)
    }
    
    private func presentSellViewController() {
        // Present sell interface
        HapticManager.shared.impact(.medium)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
