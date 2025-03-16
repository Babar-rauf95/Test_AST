//
//  BaseViewModel.swift
//  UpLevel
//
//  Created by User on 29/04/2024.
//

import Foundation

//MARK: - BaseViewModelProtocol
protocol BaseViewModelProtocols: AnyObject {
    func onFailure(error: String, type: ToastType)

}

class BaseViewModel {
}
