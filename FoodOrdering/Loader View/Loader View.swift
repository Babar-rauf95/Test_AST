//
//  Loader View.swift
//  UpLevel
//
//  Created by techelix_iOS on 4/9/24.
//

import Foundation
import UIKit

class Loader {
    static let shared = Loader()
    
    private var loaderView: UIActivityIndicatorView?
    
    func show(_ view: UIView) {
        DispatchQueue.main.async {
            if self.loaderView == nil {
                let activityIndicator = UIActivityIndicatorView(style: .large)
                activityIndicator.color = .gray
                activityIndicator.center = view.center
                activityIndicator.hidesWhenStopped = true
                view.addSubview(activityIndicator)
                
                self.loaderView = activityIndicator
            }
            self.loaderView?.startAnimating()
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.loaderView?.stopAnimating()
            self.loaderView?.removeFromSuperview()
            self.loaderView = nil
        }
    }
}
