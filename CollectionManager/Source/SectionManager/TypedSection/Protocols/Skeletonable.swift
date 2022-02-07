//
//  Skeletonable.swift
//  CollectionManager
//
//  Created by 0x01eva on 27.01.2022.
//

import UIKit


fileprivate var animationTimer: Timer?

/**
    Applies a loading animation to a view.
 */
public protocol Skeletonable {
    
    /**
        Check if animation is active.
     */
    var isSkeletonActive: Bool { get }
    
    /**
        Add loading animation on  view.
     */
    func showSkeleton(
        with setup: SkeletonSetup
    )
    
    /**
        Removes loading animation from view.
     */
    func hideSkeleton()
    
}


public extension Skeletonable where Self: UIView {
    
    /**
        Check if animation is active.
     */
    var isSkeletonActive: Bool {
        guard let sublayers = layer.sublayers else { return false }
        
        var isGradientFound: Bool = false
        sublayers.forEach {
            if $0 is CAGradientLayer {
                isGradientFound = true
                return
            }
        }
        return isGradientFound
    }
    
    /**
        Add loading animation on  view.
     */
    func showSkeleton(
        with setup: SkeletonSetup = .default
    ) {
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.masksToBounds = true
        gradientLayer.colors = [
            UIColor.gradientDarkGrey.cgColor,
            UIColor.gradientLightGrey.cgColor,
            UIColor.gradientDarkGrey.cgColor
        ]
        gradientLayer.frame = self.bounds
        
        gradientLayer.locations =  [0.35, 0.50, 0.65]
        
        switch setup.direction {
        case .topToBottom:
          gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
          gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .bottomToTop:
          gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
          gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .leftToRight:
          gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
          gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
          gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
          gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .leftTopToRightBottom:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .leftBottomToRightTop:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        case .rightTopToLeftBottom:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .rightBottomToLeftTop:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.5, -0.4, -0.3]
        animation.toValue = [1.3, 1.4, 1.5]
        animation.duration = CFTimeInterval(setup.duration)
        animation.repeatCount = .infinity
        animation.beginTime = animationTimer?.timeInterval
            ?? TimeInterval(setup.duration)
        
        gradientLayer.add(animation, forKey: "skeletonAnimation")
        self.layer.addSublayer(gradientLayer)
        
        if animationTimer == nil {
            animationTimer = Timer.scheduledTimer(
                withTimeInterval: TimeInterval(setup.duration),
                repeats: true
            ) { _ in }
        }
    }
    
    /**
        Removes loading animation from view.
     */
    func hideSkeleton() {
        guard let sublayers = layer.sublayers else { return }
        sublayers.forEach {
            if $0 is CAGradientLayer {
                self.isUserInteractionEnabled = true
                $0.removeFromSuperlayer()
            }
        }
    }
    
}

extension UITableViewCell: Skeletonable { }
extension UICollectionViewCell: Skeletonable { }
