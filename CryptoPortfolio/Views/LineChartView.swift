//
//  LineChartView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class LineChartView: UIView {
    private var dataPoints: [ChartDataPoint] = []
    private let lineLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let animationDuration: TimeInterval = Constants.Animation.chartAnimationDuration
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupChart()
    }
    
    private func setupChart() {
        backgroundColor = .clear
        
        // Setup gradient
        gradientLayer.colors = [
            Constants.Colors.primaryBlue.withAlphaComponent(0.3).cgColor,
            Constants.Colors.primaryBlue.withAlphaComponent(0.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.addSublayer(gradientLayer)
        
        // Setup line
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = Constants.Colors.primaryBlue.cgColor
        lineLayer.lineWidth = 3.0
        lineLayer.lineCap = .round
        lineLayer.lineJoin = .round
        layer.addSublayer(lineLayer)
        
        // Add theme change observer
        ThemeManager.shared.addDelegate(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        drawChart()
    }
    
    func updateData(_ newDataPoints: [ChartDataPoint]) {
        dataPoints = newDataPoints
        drawChart()
    }
    
    private func drawChart() {
        guard !dataPoints.isEmpty, bounds.width > 0, bounds.height > 0 else { return }
        
        let path = UIBezierPath()
        let gradientPath = UIBezierPath()
        
        let minValue = dataPoints.map { $0.value }.min() ?? 0
        let maxValue = dataPoints.map { $0.value }.max() ?? 1
        let valueRange = maxValue - minValue
        
        let stepX = bounds.width / CGFloat(dataPoints.count - 1)
        let padding: CGFloat = 20
        let availableHeight = bounds.height - (padding * 2)
        
        for (index, point) in dataPoints.enumerated() {
            let x = CGFloat(index) * stepX
            let normalizedValue = valueRange > 0 ? (point.value - minValue) / valueRange : 0.5
            let y = padding + availableHeight - (CGFloat(normalizedValue) * availableHeight)
            
            let cgPoint = CGPoint(x: x, y: y)
            
            if index == 0 {
                path.move(to: cgPoint)
                gradientPath.move(to: CGPoint(x: x, y: bounds.height))
                gradientPath.addLine(to: cgPoint)
            } else {
                // Use smooth curves instead of straight lines
                let previousPoint = dataPoints[index - 1]
                let prevX = CGFloat(index - 1) * stepX
                let prevNormalizedValue = valueRange > 0 ? (previousPoint.value - minValue) / valueRange : 0.5
                let prevY = padding + availableHeight - (CGFloat(prevNormalizedValue) * availableHeight)
                let previousCGPoint = CGPoint(x: prevX, y: prevY)
                
                let controlPoint1 = CGPoint(x: prevX + stepX * 0.3, y: previousCGPoint.y)
                let controlPoint2 = CGPoint(x: x - stepX * 0.3, y: cgPoint.y)
                
                path.addCurve(to: cgPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                gradientPath.addCurve(to: cgPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
        }
        
        // Close gradient path
        gradientPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        gradientPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        gradientPath.close()
        
        // Animate the line drawing
        lineLayer.path = path.cgPath
        gradientLayer.mask?.removeFromSuperlayer()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = gradientPath.cgPath
        gradientLayer.mask = maskLayer
        
        // Add smooth drawing animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        lineLayer.add(animation, forKey: "drawLine")
        
        // Add fade-in animation for gradient
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        fadeAnimation.duration = animationDuration * 0.8
        fadeAnimation.beginTime = CACurrentMediaTime() + animationDuration * 0.2
        gradientLayer.add(fadeAnimation, forKey: "fadeIn")
    }
    
    deinit {
        ThemeManager.shared.removeDelegate(self)
    }
}

extension LineChartView: ThemeManagerDelegate {
    func themeDidChange() {
        // Update colors for dark mode
        lineLayer.strokeColor = Constants.Colors.primaryBlue.cgColor
        gradientLayer.colors = [
            Constants.Colors.primaryBlue.withAlphaComponent(0.3).cgColor,
            Constants.Colors.primaryBlue.withAlphaComponent(0.0).cgColor
        ]
    }
}
