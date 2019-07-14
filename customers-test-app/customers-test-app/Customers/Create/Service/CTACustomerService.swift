//
//  CTACustomerService.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 13/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

public class CTACustomerService: NSObject {
    
    var successBlock: (() -> Void)?
    var failureBlock: ((_ error: String) -> Void)?
    
    public func save(customer: CTACustomerModel){
        var ref: DatabaseReference!
        ref = Database.database().reference().child("customers")
        
        let key = ref.childByAutoId().key
        
        do {
            let model = try FirebaseEncoder().encode(customer)
            ref.child(key!).setValue(model){ [weak self] (err, resp) in            
                
                guard err == nil else {
                    self?.failureBlock?(DEFAULT_ERROR)
                    return
                }
                
                self?.successBlock?()
            }    
            
        } catch let error {
            print(error)
            failureBlock?(DEFAULT_ERROR)
        }  
        
    }
}
