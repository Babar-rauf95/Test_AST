//
//  SelectFoodViewModel.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

protocol SelectFoodViewModelProtocols: BaseViewModelProtocols{
    func onSuccess()
    func onFailure()
}

class SelectFoodViewModel{
    //MARK: DELEGATE
    weak var delegate: SelectFoodViewModelProtocols?
    
    init(delegate: SelectFoodViewModelProtocols?) {
        self.delegate = delegate
    }
    
    
}
