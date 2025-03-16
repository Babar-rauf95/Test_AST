//
//  SignUpViewModel.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

protocol SignUpViewModelProtocols: BaseViewModelProtocols{
    func onSuccess()
}

class SignUpViewModel{
    //MARK: DELEGATE
    weak var delegate: SignUpViewModelProtocols?
    
    //MARK: STATE MAINTAINING VARIABLE(S)
    var authManager: AuthManager?
    
    init(delegate: SignUpViewModelProtocols?) {
        self.delegate = delegate
    }
        
    private func validateFields(email: String, password: String, role: String)-> Bool {
        if email.isEmpty || email == "" || password.isEmpty || password == "" || role.isEmpty || role == ""{
            self.delegate?.onFailure(error: "All fields are required.", type: .error)
            return false
        } else if !email.isValidEmail() {
            self.delegate?.onFailure(error:  "Please enter valid email.", type: .error)
            return false
        } else {
            return true
        }
    }

    
    func signUp(email: String, password: String, role: String){
        guard validateFields(email: email, password: password, role: role) else { return }
        
        AuthManager.shared.signUp(email: email, password: password, role: role) { result in
            switch result{
            case .success(let user):
                print(user)
                self.delegate?.onSuccess()

            case .failure(let error):
                self.delegate?.onFailure(error:  "\(error)", type: .error)
            }
        }
    }
}
