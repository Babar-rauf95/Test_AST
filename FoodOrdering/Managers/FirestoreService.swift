//
//  FirestoreService.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    private init() {}
    
    private let db = Firestore.firestore()

    // Fetch User Data
    func fetchUser(userID: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = snapshot?.data(),
                  let email = data["email"] as? String,
                  let role = data["role"] as? String else {
                return
            }
            let user = UserModel(uid: userID, email: email, role: role)
            completion(.success(user))
        }
    }

    // Fetch Restaurants
    func fetchRestaurants(completion: @escaping (Result<[RestaurantModel], Error>) -> Void) {
        db.collection("restaurants").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let restaurants = snapshot?.documents.compactMap { doc -> RestaurantModel? in
                let data = doc.data()
                return RestaurantModel(id: doc.documentID, name: data["name"] as? String ?? "", address: data["address"] as? String ?? "")
            } ?? []
            
            completion(.success(restaurants))
        }
    }

    // Place Order
    func placeOrder(order: OrderModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let orderRef = db.collection("orders").document(order.id)
        let orderData: [String: Any] = [
            "userID": order.userID,
            "restaurantID": order.restaurantID,
            "totalAmount": order.totalAmount,
            "status": order.status,
            "timestamp": order.timestamp
        ]
        
        orderRef.setData(orderData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
