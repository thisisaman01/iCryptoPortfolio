//
//  CurrencySelectionViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

// MARK: - Currency Model and Selection
struct Currency {
    let symbol: String
    let name: String
    let icon: String?
}

class CurrencySelectionViewController: UIViewController {
    private let tableView = UITableView()
    var onCurrencySelected: ((Currency) -> Void)?
    
    private let currencies = [
        Currency(symbol: "BTC", name: "Bitcoin", icon: "bitcoinIcon"),
        Currency(symbol: "ETH", name: "Ethereum", icon: "ethereumIcon"),
        Currency(symbol: "LTC", name: "Litecoin", icon: "litecoinIcon"),
        Currency(symbol: "INR", name: "Indian Rupee", icon: "rupeeIcon"),
        Currency(symbol: "USD", name: "US Dollar", icon: "dollarIcon"),
        Currency(symbol: "EUR", name: "Euro", icon: "euroIcon")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        title = "Select Currency"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CurrencyCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
}

extension CurrencySelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        let currency = currencies[indexPath.row]
        
        cell.textLabel?.text = "\(currency.symbol) - \(currency.name)"
        cell.textLabel?.font = Constants.Fonts.body
        cell.backgroundColor = .clear
        cell.selectionStyle = .default
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCurrency = currencies[indexPath.row]
        onCurrencySelected?(selectedCurrency)
        
        dismiss(animated: true)
    }
}
