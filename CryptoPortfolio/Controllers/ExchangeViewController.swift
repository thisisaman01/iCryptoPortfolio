//
//  ExchangeViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

class ExchangeViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = UIView()
    private let swapContainerView = CardView()
    private let fromCurrencyView = CurrencySelectionView()
    private let swapButton = UIButton(type: .system)
    private let toCurrencyView = CurrencySelectionView()
    private let rateInfoView = RateInfoView()
    private let exchangeButton = GradientButton()
    
    private let dataService: DataServiceProtocol = MockDataService.shared
    private var exchangeRate: ExchangeRate?
    
    private var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupKeyboardHandling()
        loadExchangeRate()
        
        // Add theme change observer
        ThemeManager.shared.addDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reset form when view appears
        resetExchangeForm()
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        setupHeaderView()
        setupSwapContainer()
        setupRateInfo()
        setupExchangeButton()
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = Constants.Colors.textPrimary
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.isHidden = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Exchange"
        titleLabel.font = Constants.Fonts.title1
        titleLabel.textColor = Constants.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupSwapContainer() {
        swapContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(swapContainerView)
        
        // From currency
        fromCurrencyView.configure(
            symbol: "ETH",
            name: "Ethereum",
            amount: "",
            balance: "10.254"
        )
        fromCurrencyView.isFromCurrency = true
        fromCurrencyView.onAmountChanged = { [weak self] amount in
            self?.calculateExchange(fromAmount: amount)
        }
        fromCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        swapContainerView.addSubview(fromCurrencyView)
        
        // Swap button
        swapButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        swapButton.backgroundColor = Constants.Colors.primaryBlue
        swapButton.tintColor = .white
        swapButton.layer.cornerRadius = 20
        swapButton.layer.shadowColor = UIColor.black.cgColor
        swapButton.layer.shadowOpacity = 0.2
        swapButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        swapButton.layer.shadowRadius = 4
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        swapButton.translatesAutoresizingMaskIntoConstraints = false
        swapContainerView.addSubview(swapButton)
        
        // To currency
        toCurrencyView.configure(
            symbol: "INR",
            name: "Indian Rupee",
            amount: "",
            balance: "4,36,804"
        )
        toCurrencyView.isFromCurrency = false
        toCurrencyView.onAmountChanged = { [weak self] amount in
            self?.calculateExchange(toAmount: amount)
        }
        toCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        swapContainerView.addSubview(toCurrencyView)
        
        NSLayoutConstraint.activate([
            fromCurrencyView.topAnchor.constraint(equalTo: swapContainerView.topAnchor, constant: Constants.Layout.padding),
            fromCurrencyView.leadingAnchor.constraint(equalTo: swapContainerView.leadingAnchor, constant: Constants.Layout.padding),
            fromCurrencyView.trailingAnchor.constraint(equalTo: swapContainerView.trailingAnchor, constant: -Constants.Layout.padding),
            fromCurrencyView.heightAnchor.constraint(equalToConstant: 100),
            
            swapButton.topAnchor.constraint(equalTo: fromCurrencyView.bottomAnchor, constant: -20),
            swapButton.centerXAnchor.constraint(equalTo: swapContainerView.centerXAnchor),
            swapButton.widthAnchor.constraint(equalToConstant: 40),
            swapButton.heightAnchor.constraint(equalToConstant: 40),
            
            toCurrencyView.topAnchor.constraint(equalTo: fromCurrencyView.bottomAnchor, constant: 20),
            toCurrencyView.leadingAnchor.constraint(equalTo: swapContainerView.leadingAnchor, constant: Constants.Layout.padding),
            toCurrencyView.trailingAnchor.constraint(equalTo: swapContainerView.trailingAnchor, constant: -Constants.Layout.padding),
            toCurrencyView.heightAnchor.constraint(equalToConstant: 100),
            toCurrencyView.bottomAnchor.constraint(equalTo: swapContainerView.bottomAnchor, constant: -Constants.Layout.padding)
        ])
    }
    
    private func setupRateInfo() {
        rateInfoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rateInfoView)
    }
    
    private func setupExchangeButton() {
        exchangeButton.setTitle("Exchange", for: .normal)
        exchangeButton.addTarget(self, action: #selector(exchangeButtonTapped), for: .touchUpInside)
        exchangeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(exchangeButton)
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
            
            // Swap container
            swapContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            swapContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            swapContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Rate info
            rateInfoView.topAnchor.constraint(equalTo: swapContainerView.bottomAnchor, constant: 20),
            rateInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            rateInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            
            // Exchange button
            exchangeButton.topAnchor.constraint(equalTo: rateInfoView.bottomAnchor, constant: 30),
            exchangeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.padding),
            exchangeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.padding),
            exchangeButton.heightAnchor.constraint(equalToConstant: 56),
//            exchangeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            exchangeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150)

        ])
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardHeight = keyboardFrame.height
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        // Scroll to active text field if needed - FIXED VERSION
        if fromCurrencyView.amountTextField.isFirstResponder {
            let rect = fromCurrencyView.amountTextField.convert(fromCurrencyView.amountTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        } else if toCurrencyView.amountTextField.isFirstResponder {
            let rect = toCurrencyView.amountTextField.convert(toCurrencyView.amountTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func loadExchangeRate() {
        dataService.getExchangeRate(from: "ETH", to: "INR") { [weak self] rate in
            self?.exchangeRate = rate
            self?.rateInfoView.configure(with: rate)
        }
    }
    
    private func calculateExchange(fromAmount: String? = nil, toAmount: String? = nil) {
        guard let rate = exchangeRate else { return }
        
        if let fromAmount = fromAmount, !fromAmount.isEmpty, let amount = Double(fromAmount) {
            let convertedAmount = amount * rate.rate
            toCurrencyView.setAmount(String(format: "%.2f", convertedAmount))
        } else if let toAmount = toAmount, !toAmount.isEmpty, let amount = Double(toAmount) {
            let convertedAmount = amount / rate.rate
            fromCurrencyView.setAmount(String(format: "%.6f", convertedAmount))
        }
    }
    
    private func resetExchangeForm() {
        fromCurrencyView.setAmount("")
        toCurrencyView.setAmount("")
        dismissKeyboard()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func swapButtonTapped() {
        HapticManager.shared.impact(.medium)
        
        // Animate swap with smooth rotation
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.swapButton.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.swapButton.transform = .identity
            })
        }
        
        // Swap the currency data with animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            // Animate position swap
            let fromFrame = self.fromCurrencyView.frame
            let toFrame = self.toCurrencyView.frame
            
            self.fromCurrencyView.frame = toFrame
            self.toCurrencyView.frame = fromFrame
        }) { _ in
            // Swap the actual data
            self.swapCurrencyData()
        }
    }
    
    private func swapCurrencyData() {
        let fromSymbol = fromCurrencyView.symbol
        let fromName = fromCurrencyView.name
        let fromAmount = fromCurrencyView.amount
        let fromBalance = fromCurrencyView.balance
        
        fromCurrencyView.configure(
            symbol: toCurrencyView.symbol,
            name: toCurrencyView.name,
            amount: toCurrencyView.amount,
            balance: toCurrencyView.balance
        )
        
        toCurrencyView.configure(
            symbol: fromSymbol,
            name: fromName,
            amount: fromAmount,
            balance: fromBalance
        )
        
        // Reload exchange rate for new currency pair
        loadExchangeRate()
    }
    
    @objc private func exchangeButtonTapped() {
        HapticManager.shared.notification(.success)
        
        // Validate input
        guard !fromCurrencyView.amount.isEmpty else {
            showAlert(title: "Invalid Amount", message: "Please enter an amount to exchange.")
            return
        }
        
        guard let amount = Double(fromCurrencyView.amount), amount > 0 else {
            showAlert(title: "Invalid Amount", message: "Please enter a valid amount.")
            return
        }
        
        // Show success animation
        showExchangeSuccess()
    }
    
    private func showExchangeSuccess() {
        let alert = UIAlertController(title: "Exchange Successful! 🎉", message: "Your exchange has been processed successfully.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "View Transaction", style: .default) { _ in
            // Navigate to transactions
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 2
            }
        })
        
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            self.resetExchangeForm()
        })
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        ThemeManager.shared.removeDelegate(self)
    }
}

extension ExchangeViewController: ThemeManagerDelegate {
    func themeDidChange() {
        view.backgroundColor = Constants.Colors.backgroundColor
    }
}
