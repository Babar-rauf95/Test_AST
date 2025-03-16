//
//  ResturantTVC.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

import UIKit

class ResturantTVC: UITableViewCell, IdentifiableProtocol {

    @IBOutlet weak var imgRestuarant: UIImageView!
    @IBOutlet weak var lblRestuarantName: UILabel!
    @IBOutlet weak var lblRestuarantEconomy: UILabel!
    
    func setData(){
        self.imgRestuarant.image = UIImage(named: "")
        self.lblRestuarantName.text = "Restuarant Name"
        self.lblRestuarantEconomy.text = "Economy"
    }
    
}
