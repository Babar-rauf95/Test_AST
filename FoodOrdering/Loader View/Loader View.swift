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
    
    var hudView = MBProgressHUD()
    
    func show(_ view: UIView){
        //let window = UIApplication.shared.windows.last as! UIWindow
        hudView = MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hide(_ view: UIView){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                print("removing hud on webservices")
                MBProgressHUD.hide(for: view, animated: false)
            }
        }
    }

}
