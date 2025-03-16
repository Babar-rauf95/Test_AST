//
//  ResturantViewModel.swift
//  FoodOrdering
//
//  Created by User on 16/03/2025.
//

protocol ResturantViewModelProtocols: BaseViewModelProtocols{
    func onSucess()
    func onSuccessLogout()
}

class RestaurantViewModel{
    //MARK: DELEGATE
    weak var delegate: ResturantViewModelProtocols?
    
    init(delegate: ResturantViewModelProtocols?) {
        self.delegate = delegate
    }
    
    func logout(){
        AuthManager.shared.logout { isLogout in
            if isLogout{
                self.delegate?.onSuccessLogout()
            } else {
                self.delegate?.onFailure(error: "Cannot logout at the moment", type: .error)
            }
        }
    }
    
//    func getRestuarants(){
//        FirestoreService.shared.fetchRestaurants { results in
//            switch results{
//            case .success(let resturants: [RestaurantModel]):
//                self.delegate?.onSucess()
//            case .failure(Error)
//            }
//        }
//    }
}
