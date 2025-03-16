//
//  CustomCornerRadius.swift
//  UpLevel
//
//  Created by User on 12/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class CustomCornerRadiusView: UIView {

    // IBInspectable properties for each corner
    @IBInspectable var topLeftRadius: CGFloat = 0 {
        didSet {
            updateCornerRadii()
        }
    }
    
    @IBInspectable var topRightRadius: CGFloat = 0 {
        didSet {
            updateCornerRadii()
        }
    }
    
    @IBInspectable var bottomLeftRadius: CGFloat = 0 {
        didSet {
            updateCornerRadii()
        }
    }
    
    @IBInspectable var bottomRightRadius: CGFloat = 0 {
        didSet {
            updateCornerRadii()
        }
    }
    
    // Method to update the corner radii
    private func updateCornerRadii() {
        // Define which corners to round
        var cornerMask = CACornerMask()
        
        if topLeftRadius > 0 {
            cornerMask.insert(.layerMinXMinYCorner)
        }
        if topRightRadius > 0 {
            cornerMask.insert(.layerMaxXMinYCorner)
        }
        if bottomLeftRadius > 0 {
            cornerMask.insert(.layerMinXMaxYCorner)
        }
        if bottomRightRadius > 0 {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }
        
        // Apply the corner radii and masks
        layer.cornerRadius = max(topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius) // The largest radius
        layer.maskedCorners = cornerMask
        layer.masksToBounds = true
    }
}
