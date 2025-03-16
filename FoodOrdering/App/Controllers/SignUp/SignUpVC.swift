//
//  SignUpVC.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

import UIKit

class SignUpVC: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfRole: UITextField!

    @IBOutlet weak var btnSignUp: UIButton!
    
    var viewModel: SignUpViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

//MARK: - Helper Methods
extension SignUpVC{
    func setupViewModel(viewModel: SignUpViewModel){
        self.viewModel = viewModel
    }
}

//MARK: - Actions
extension SignUpVC{
    @IBAction func onBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBtnSignUp(_ sender: UIButton) {
        let email = self.tfEmail.text ?? ""
        let pass = self.tfPassword.text ?? ""
        let role = self.tfRole.text ?? ""
        
        self.viewModel?.signUp(email: email, password: pass, role: role)
    }

}

//MARK: - SignUpViewModelProtocols
extension SignUpVC: SignUpViewModelProtocols{
    func onSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onFailure() {
        
    }
}
