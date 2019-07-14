//
//  CTACustomerListViewModel.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 14/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit

public protocol CTACustomerListViewModelDelegate : class {
    func onSuccess(customers: [CTACustomerModel])
    func onError(message: String)
}

public class CTACustomerListViewModel: NSObject {

    public weak var delegate: CTACustomerListViewModelDelegate?
    private var service: CTACustomerService!
    
    public override init(){
        super.init()
        
        service = CTACustomerService()
        
        service.successBlock = { [weak self] (response) in
            guard let customers = response as? [CTACustomerModel] else { return }
            self?.delegate?.onSuccess(customers: customers)
        }
        
        service.failureBlock = { [weak self] (error) in 
            self?.delegate?.onError(message: error)
        }
    }
    
    public func getCustomers() {
        service.get()
    }
}
