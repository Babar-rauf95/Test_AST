//
//  ViewController.swift
//  UpLevel
//
//  Created by techelix_iOS on 3/19/24.
//

import UIKit
import MessageUI

enum AttendanceDuration{
    case fromTodayLastThirtyDays
    case currentMonthStartEnd
    case oneWeek
}

enum ToastType {
    case error
    case success
}

class BaseViewController: UIViewController, IdentifiableProtocol, Alertable {
    
    private var viewModel: BaseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BaseViewModel()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}

//MARK: - Helper Methods
extension BaseViewController{
    
    //MARK: HideKeyBoard
    func hideKeyboardWhenTappedAround() {
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertWithTitle(_ title:String?, message:String?,shouldShowImage:Bool = true) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - BaseViewModelProtocols
extension BaseViewController: BaseViewModelProtocols {
    func onFailure(error: String, type: ToastType) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        
        switch type {
        case .error:
            alert.view.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            alert.view.tintColor = UIColor.white
        case .success:
            alert.view.backgroundColor = UIColor.green.withAlphaComponent(0.8)
            alert.view.tintColor = UIColor.white
        }
        
        present(alert, animated: true)
        
        // Auto-dismiss the alert after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true)
        }
    }
    
    func isLoading(status: Bool){
        status ?  Loader.shared.show(self.view) : Loader.shared.hide()
    }
}
