//
//  CustomerViewModel.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 13/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit


public protocol CTACustomerViewModelDelegate : class {
    func onSaveSuccess(message: String)
    func onSaveError(message: String)
    func onRequiredField(message: String)
}

public class CTACustomerViewModel: NSObject {

    public weak var delegate: CTACustomerViewModelDelegate?
    private var service: CTACustomerService!
    
    public override init() {
        super.init()
        
        service = CTACustomerService()
        
        service.successBlock = { [weak self] (response) in
            self?.delegate?.onSaveSuccess(message: "Los datos se guardaron correctamente")
        }
        
        service.failureBlock = { [weak self] (error) in 
            self?.delegate?.onSaveError(message: error)
        }
    }
    
    public func save(name: String?, lastname: String?, age: String?, birthdate: Date?){
        
        guard name != EMPTY_STRING, lastname != EMPTY_STRING, age != EMPTY_STRING, let birthdate = birthdate  else {
            delegate?.onRequiredField(message: "Debe completar todos los datos")
            return
        }
        
        let customer = CTACustomerModel(name: name!, lastname: lastname!, age: Int(age!) ?? 0, birthdate: birthdate.getDateString())
        service.save(customer: customer)
    }
}
