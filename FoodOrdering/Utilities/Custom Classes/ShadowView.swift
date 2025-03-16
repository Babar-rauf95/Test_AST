//
//  ShadowView.swift
//  UpLevel
//
//  Created by User on 08/07/2024.
//

import Foundation
import UIKit

@IBDesignable
class ShadowView: UIView {
    
    @IBInspectable var shadowOffsetWidth: Int = -1
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var lightModeShadowColor: UIColor? = .lightGray
    @IBInspectable var darkModeShadowColor: UIColor? = UIColor(white: 0.1, alpha: 1.0) // Subtle dark gray
    @IBInspectable var customShadowOpacity: Float = 1.0
    @IBInspectable var darkModeShadowOpacity: Float = 0.5 // Reduced opacity for dark mode
    @IBInspectable var isCircular: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Check if the userInterfaceStyle has changed
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            applyShadow()
        }
    }
    
    private func applyShadow() {
        if self.isCircular {
            layer.cornerRadius = self.frame.height / 2.0
        }
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        layer.masksToBounds = false
        
        if isDarkMode() {
            layer.shadowColor = darkModeShadowColor?.cgColor
            layer.shadowOpacity = darkModeShadowOpacity
        } else {
            layer.shadowColor = lightModeShadowColor?.cgColor
            layer.shadowOpacity = customShadowOpacity
        }
        
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowPath = shadowPath.cgPath
    }
    
    private func isDarkMode() -> Bool {
        return traitCollection.userInterfaceStyle == .dark
    }
}

//import Foundation
//import UIKit
//
//@IBDesignable
//class ShadowView: UIView {
//    
//    @IBInspectable var shadowOffsetWidth: Int = -1
//    @IBInspectable var shadowOffsetHeight: Int = 1
//    @IBInspectable var customShadowColor: UIColor? = .lightGray
//    @IBInspectable var customShadowOpacity: Float = 1.0
//    @IBInspectable var isCircular: Bool = false
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        applyShadow()
//    }
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        // Check if the userInterfaceStyle has changed
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            applyShadow()
//        }
//    }
//    
//    private func applyShadow() {
//        // Make the view circular if needed
//        if self.isCircular {
//            layer.cornerRadius = self.frame.height / 2.0
//        }
//        
//        if isDarkMode() {
//            layer.borderColor = UIColor.white.cgColor
//            layer.borderWidth = 0.0
//        } else {
//            layer.borderColor = UIColor.clear.cgColor
//            layer.borderWidth = 0.0
//        }
//        
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
//        layer.masksToBounds = false
//        layer.shadowColor = customShadowColor?.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
//        layer.shadowOpacity = customShadowOpacity
//        layer.shadowPath = shadowPath.cgPath
//    }
//    
//    private func isDarkMode() -> Bool {
//        return traitCollection.userInterfaceStyle == .dark
//    }
//}


//import Foundation
//import UIKit
//
//@IBDesignable
//class ShadowView: UIView {
//
//    @IBInspectable var shadowOffsetWidth: Int = -1
//    @IBInspectable var shadowOffsetHeight: Int = 1
//    @IBInspectable var customShadowColor: UIColor? = .lightGray
//    @IBInspectable var customShadowOpacity: Float = 1.0
//    @IBInspectable var isCircular: Bool = false
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Make the view circular if needed
//        if self.isCircular {
//            layer.cornerRadius = self.frame.height / 2.0
//        }
//
//        if isDarkMode() {
//            layer.borderColor = UIColor.white.cgColor
//            layer.borderWidth = 0.0
//        } else {
//            layer.borderColor = UIColor.clear.cgColor
//            layer.borderWidth = 0.0
//
//            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
//            layer.masksToBounds = false
//            layer.shadowColor = customShadowColor?.cgColor // Apply the custom shadow color to the layer
//            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
//            layer.shadowOpacity = customShadowOpacity // Apply the custom shadow opacity to the layer
//            layer.shadowPath = shadowPath.cgPath
//        }
//    }
//}
