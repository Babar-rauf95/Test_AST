//
//  UITableView + Extension.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

import UIKit

// MARK: - Register Cell, Header, and Footer
extension UITableView {
    func registerCell(nib name: String) {
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }

    func registerHeaderFooter(nib name: String) {
        self.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
    }
}
