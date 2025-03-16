//
//  HelperProtocols.swift
//  UpLevel
//
//  Created by techelix_iOS on 3/21/24.
//

import Foundation
import UIKit

protocol IdentifiableProtocol{
    static func getIdentifier() -> String
}

extension IdentifiableProtocol {
    static var name: String {
        return String(describing: self)
    }

    static func getIdentifier() -> String {
        return self.name
    }
}

public protocol Alertable {}
public extension Alertable where Self: UIViewController {
    
    //MARK: - Show_Alert
    func showAlert(title: String = "",
                   message: String,
                   completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: completion)
        }
    }
    
    //MARK: - Show_Alert_With_Yes_No
    func showAlertWithYesNo(title: String?, message: String?, yesPressed: @escaping ()->Void, noPressed: @escaping ()->Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (action) in
            yesPressed()
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (action) in
            noPressed()
        }
        alertController.addAction(action)
        alertController.addAction(noAction)
        self.present(alertController, animated: true)
    }
    
    //MARK: - Show_Alert_With_Single_Button
    func showAlertWithSingleButton(title: String?, buttonTitle: String, message: String?, yesPressed: @escaping ()->Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { (action) in
            yesPressed()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}

protocol TimestampSortable {
    var timeStamp: String { get }
}
