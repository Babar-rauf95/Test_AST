//
//  LoginViewModel.swift
//  FoodOrdering
//
//  Created by M Usman Bin Rehan on 16/03/2025.
//

protocol LoginViewModelProtocols: BaseViewModelProtocols{
    func onSuccess(user: UserModel)
    //func onFailure(error: String, type: ToastType)
}

class LoginViewModel{
    //MARK: DELEGATE
    weak var delegate: LoginViewModelProtocols?
    
    init(delegate: LoginViewModelProtocols?) {
        self.delegate = delegate
    }
    
    private func validateFields(email: String, password: String)-> Bool {
        if email.isEmpty || email == "" || password.isEmpty || password == ""{
            self.delegate?.onFailure(error: "All fields are required.", type: .error)
            return false
        } else if !email.isValidEmail() {
            self.delegate?.onFailure(error: "Please enter valid email.", type: .error)
            return false
        } else {
            return true
        }
    }
    
    func login(email: String, password: String){
        guard validateFields(email: email, password: password) else { return }
        
        AuthManager.shared.login(email: email, password: password) { result in
            switch result{
            case .success(let user):
                self.delegate?.onSuccess(user: user)
            case .failure(let error):
                self.delegate?.onFailure(error: "\(error.localizedDescription)", type: .error)
            }
        }
    }
}
