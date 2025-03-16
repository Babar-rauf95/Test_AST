//
//  AuthManager.swift
//  FoodOrdering
//
//  Created by M Usman Bin Rehan on 16/03/2025.
//

import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let coreDataManager = CoreDataManager.shared
    
    func signUp(email: String, password: String, role: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = result?.user else { return }
            
            let userData = ["email": email, "role": role]
            self.db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let userModel = UserModel(uid: user.uid, email: email, role: role)
                    completion(.success(userModel))
                }
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = result?.user else { return }
            
            self.db.collection("users").document(user.uid).getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                //guard let data = snapshot?.data(), let role = data["role"] as? String else { return }
                
                let userModel = UserModel(uid: user.uid, email: user.email ?? "", role: "role")
                self.coreDataManager.saveUserSession(userID: user.uid, email: email, role: "role")
                
                completion(.success(userModel))
            }
        }
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        self.coreDataManager.deleteUserSession()
        completion(true)
    }
}
