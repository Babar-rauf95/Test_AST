//
//  UserModeule.swift
//  FoodOrdering
//
//  Created by M Usman Bin Rehan on 16/03/2025.
//

struct UserModel {
    let uid: String
    let email: String
    let role: String
}

struct RestaurantModel {
    let id: String
    let name: String
    let address: String
}

struct OrderModel {
    let id: String
    let userID: String
    let restaurantID: String
    let totalAmount: Double
    let status: String
    let timestamp: String
}
