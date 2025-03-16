//
//  ResturantVC.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

import UIKit

class ResturantVC: BaseViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: RestaurantViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
        
}

//MARK: - Helper Methods
extension ResturantVC{
    func setupViewModel(viewModel: RestaurantViewModel){
        self.viewModel = viewModel
    }
    
    func setupUI(){
        tableView.registerCell(nib: ResturantTVC.name)
    }
}

//MARK: - Actions
extension ResturantVC{
    @IBAction func onBtnLogout(_ sender: UIButton) {
        self.viewModel?.logout()
    }

}

//MARK: - UITableViewDelegate
extension ResturantVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResturantTVC.name, for: indexPath) as? ResturantTVC else { return UITableViewCell() }
        return cell
    }
}

//MARK: - UITableViewDataSource
extension ResturantVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

//MARK: - ResturantViewModelProtocols
extension ResturantVC: ResturantViewModelProtocols{
    func onSuccessLogout() {
        SceneDelegate.shared.changeRootViewController()
    }
    
    func onFailureLogout() {
        
    }
    
    func onSucess() {
        tableView.reloadData()
    }
    
    func onFailure() {
        
    }
}
