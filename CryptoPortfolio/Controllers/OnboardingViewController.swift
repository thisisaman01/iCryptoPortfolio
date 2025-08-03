//
//  OnboardingViewController.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit

// MARK: - Onboarding Flow
class OnboardingViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let getStartedButton = GradientButton()
    
    private let onboardingData = [
        OnboardingPage(
            title: "Track Your Portfolio",
            subtitle: "Monitor your crypto investments in real-time with beautiful charts and insights",
            imageName: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Secure Transactions",
            subtitle: "Send, receive, and exchange cryptocurrencies with bank-level security",
            imageName: "shield.checkered"
        ),
        OnboardingPage(
            title: "Stay Informed",
            subtitle: "Get real-time price alerts and market insights to make informed decisions",
            imageName: "bell.badge"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboarding()
    }
    
    private func setupOnboarding() {
        view.backgroundColor = .systemBackground
        
        // Setup scroll view for pages
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Page control
        pageControl.numberOfPages = onboardingData.count
        pageControl.currentPageIndicatorTintColor = Constants.Colors.primaryBlue
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        // Get started button
        getStartedButton.setTitle("Get Started", for: .normal)
        getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(getStartedButton)
        
        setupOnboardingPages()
        setupConstraints()
    }
    
    private func setupOnboardingPages() {
        let pageWidth = view.bounds.width
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(onboardingData.count), height: 0)
        
        for (index, pageData) in onboardingData.enumerated() {
            let pageView = createOnboardingPage(data: pageData)
            pageView.frame = CGRect(
                x: pageWidth * CGFloat(index),
                y: 0,
                width: pageWidth,
                height: view.bounds.height - 200
            )
            scrollView.addSubview(pageView)
        }
    }
    
    private func createOnboardingPage(data: OnboardingPage) -> UIView {
        let pageView = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: data.imageName)
        imageView.tintColor = Constants.Colors.primaryBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = data.title
        titleLabel.font = Constants.Fonts.title1
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = data.subtitle
        subtitleLabel.font = Constants.Fonts.body
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pageView.addSubview(imageView)
        pageView.addSubview(titleLabel)
        pageView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: pageView.topAnchor, constant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -40),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -40)
        ])
        
        return pageView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -30),
            
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            getStartedButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func getStartedTapped() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        let mainTabBar = MainTabBarController()
        if let scene = view.window?.windowScene {
            if let window = scene.windows.first {
                window.rootViewController = mainTabBar
                
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
}
