//
//  NotificationTableViewCell.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class NotificationTableViewCell: UITableViewCell {
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    private let unreadIndicator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .default
        
        // Icon container
        iconContainerView.layer.cornerRadius = 20
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconContainerView)
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconImageView)
        
        // Title
        titleLabel.font = Constants.Fonts.callout
        titleLabel.textColor = Constants.Colors.textPrimary
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Message
        messageLabel.font = Constants.Fonts.subheadline
        messageLabel.textColor = Constants.Colors.textSecondary
        messageLabel.numberOfLines = 2
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)
        
        // Time
        timeLabel.font = Constants.Fonts.caption
        timeLabel.textColor = Constants.Colors.textSecondary
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        // Unread indicator
        unreadIndicator.backgroundColor = Constants.Colors.primaryBlue
        unreadIndicator.layer.cornerRadius = 4
        unreadIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(unreadIndicator)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Icon container
            iconContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconContainerView.widthAnchor.constraint(equalToConstant: 40),
            iconContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Unread indicator
            unreadIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            unreadIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            unreadIndicator.widthAnchor.constraint(equalToConstant: 8),
            unreadIndicator.heightAnchor.constraint(equalToConstant: 8),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: unreadIndicator.leadingAnchor, constant: -8),
            
            // Message
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Time
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    func configure(with notification: NotificationItem) {
        titleLabel.text = notification.title
        messageLabel.text = notification.message
        timeLabel.text = notification.time
        
        iconContainerView.backgroundColor = notification.type.color
        iconImageView.image = UIImage(systemName: notification.type.icon)
        
        unreadIndicator.isHidden = notification.isRead
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationTableViewCell
        cell.configure(with: notifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticManager.shared.impact(.light)
        
        // Handle notification tap
        let notification = notifications[indexPath.row]
        // Navigate based on notification type
    }
}

// MARK: - Helper Extension for Finding View Controller
extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
