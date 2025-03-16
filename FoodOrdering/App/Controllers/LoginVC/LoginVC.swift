//
//  LoginVC.swift
//  FoodOrdering
//
//  Created by M Usman Bin Rehan on 16/03/2025.
//

import UIKit

class LoginVC: UIViewController, IdentifiableProtocol, Alertable {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfRole: UITextField!

    @IBOutlet weak var btnLogin: UIButton!
    
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVM()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Helper Methods
extension LoginVC{
    func setupViewModel(viewModel: LoginViewModel){
        self.viewModel = viewModel
    }
    
    func initializeVM(){
        let vm = LoginViewModel(delegate: self)
        self.viewModel = vm
    }
}

// MARK: - Actions
extension LoginVC{
    @IBAction func onBtnLogin(_ sender: UIButton) {
        let email = self.tfEmail.text ?? ""
        let pass = self.tfPassword.text ?? ""
        
        Loader.shared.show(self.view)
        self.viewModel?.login(email: email, password: pass)
        
//        navigateToMainScreen()
    }
    
    @IBAction func onBtnDontHaveAnAccount(_ sender: UIButton) {
        navigateToSignup()
    }

}

// MARK: - Navigation
extension LoginVC{
    func navigateToSignup(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: SignUpVC.name) as! SignUpVC
        
        let viewModel = SignUpViewModel(delegate: vc)
        vc.setupViewModel(viewModel: viewModel)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - LoginViewModelProtocols
extension LoginVC: LoginViewModelProtocols{
    
    func onSuccess(user: UserModel) {
        Loader.shared.hide()
        
        SceneDelegate.shared.changeRootViewController()
    }
    
    func onFailure(error: String, type: ToastType) {
        Loader.shared.hide()
        
        showAlertWithSingleButton(title: error, buttonTitle: "OK", message: nil) {
            self.dismiss(animated: true)
        }
    }
    
//    func onFailure() {
//        Loader.shared.hide()
//        
//        showMessage(message: "Cannot Login", type: .error)
//    }
    
    
}
