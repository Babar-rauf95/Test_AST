//
//  BaseViewModel.swift
//  UpLevel
//
//  Created by User on 29/04/2024.
//

import Foundation

//MARK: - BaseViewModelProtocol
protocol BaseViewModelProtocols: AnyObject {
    func isLoading(status: Bool)
    func showMessage(message: String,type: ToastType)
}

class BaseViewModel {
}
