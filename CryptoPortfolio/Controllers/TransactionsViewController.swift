//
//  TransactionsViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


// MARK: - Transactions View Controller
class TransactionsViewController: UIViewController {
    private let headerView = UIView()
    private let portfolioValueCard = CardView()
    private let actionButtonsStackView = UIStackView()
    private let tableView = UITableView()
    
    private let dataService: DataServiceProtocol = MockDataService.shared
    private var transactions: [Transaction] = []
    private var portfolio: Portfolio?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadData()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        // Header
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        setupHeaderView()
        setupPortfolioCard()
        setupActionButtons()
        setupTableView()
    }
    
    private func setupHeaderView() {
        let titleLabel = UILabel()
        titleLabel.text = "Transactions"
        titleLabel.font = Constants.Fonts.title1
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let filterButton = UIButton(type: .system)
        filterButton.setTitle("Last 4 days", for: .normal)
        filterButton.titleLabel?.font = Constants.Fonts.body
        filterButton.setTitleColor(Constants.Colors.primaryBlue, for: .normal)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            filterButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            filterButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupPortfolioCard() {
        portfolioValueCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(portfolioValueCard)
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            Constants.Colors.gradientStart.cgColor,
            Constants.Colors.gradientEnd.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = Constants.Layout.cornerRadius
        portfolioValueCard.layer.insertSublayer(gradientLayer, at: 0)
        
        let valueLabel = UILabel()
        valueLabel.text = "1,57,342.05"
        valueLabel.font = Constants.Fonts.largeTitle
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let changeLabel = UILabel()
        changeLabel.text = "₹1342 +4.6%"
        changeLabel.font = Constants.Fonts.body
        changeLabel.textColor = .white.withAlphaComponent(0.9)
        changeLabel.textAlignment = .center
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        portfolioValueCard.addSubview(valueLabel)
        portfolioValueCard.addSubview(changeLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: portfolioValueCard.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: portfolioValueCard.topAnchor, constant: 20),
            
            changeLabel.centerXAnchor.constraint(equalTo: portfolioValueCard.centerXAnchor),
            changeLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 8)
        ])
        
        DispatchQueue.main.async {
            gradientLayer.frame = self.portfolioValueCard.bounds
        }
    }
    
    private func setupActionButtons() {
        actionButtonsStackView.axis = .horizontal
        actionButtonsStackView.distribution = .fillEqually
        actionButtonsStackView.spacing = 12
        actionButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButtonsStackView)
        
        let sendButton = createActionButton(title: "Send", icon: "arrow.up.circle.fill")
        let receiveButton = createActionButton(title: "Receive", icon: "arrow.down.circle.fill")
        let exchangeButton = createActionButton(title: "Exchange", icon: "arrow.2.circlepath.circle.fill")
        
        actionButtonsStackView.addArrangedSubview(sendButton)
        actionButtonsStackView.addArrangedSubview(receiveButton)
        actionButtonsStackView.addArrangedSubview(exchangeButton)
    }
    
    private func createActionButton(title: String, icon: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.titleLabel?.font = Constants.Fonts.body
        button.setTitleColor(.label, for: .normal)
        button.tintColor = Constants.Colors.primaryBlue
        button.backgroundColor = Constants.Colors.cardBackground
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        // Arrange image and title vertically
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: -button.imageView!.frame.width, bottom: -8, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: -button.titleLabel!.frame.width)
        
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.padding),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Portfolio card
            portfolioValueCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            portfolioValueCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.padding),
            portfolioValueCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.padding),
            portfolioValueCard.heightAnchor.constraint(equalToConstant: 100),
            
            // Action buttons
            actionButtonsStackView.topAnchor.constraint(equalTo: portfolioValueCard.bottomAnchor, constant: 20),
            actionButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.padding),
            actionButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.padding),
            actionButtonsStackView.heightAnchor.constraint(equalToConstant: 60),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: actionButtonsStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadData() {
        dataService.getTransactions { [weak self] transactions in
            self?.transactions = transactions
            self?.tableView.reloadData()
        }
        
        dataService.getPortfolio { [weak self] portfolio in
            self?.portfolio = portfolio
            // Update portfolio card if needed
        }
    }
    
    @objc private func actionButtonTapped(_ sender: UIButton) {
        HapticManager.shared.impact(.medium)
        
        if let title = sender.titleLabel?.text {
            switch title {
            case "Exchange":
                tabBarController?.selectedIndex = 1
            default:
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = portfolioValueCard.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = portfolioValueCard.bounds
        }
    }
}

// MARK: - Transactions View Controller Table View Extension
extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        cell.configure(with: transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticManager.shared.impact(.light)
    }
}
