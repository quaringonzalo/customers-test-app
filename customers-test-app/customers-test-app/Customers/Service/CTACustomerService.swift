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
    
    var successBlock: ((_ result: Any?) -> Void)?
    var failureBlock: ((_ error: String) -> Void)?
    
    private func getDatabaseReference() -> DatabaseReference {
        return Database.database().reference().child("customers")
    }
    
    public func save(customer: CTACustomerModel){
        let ref = getDatabaseReference()
        
        do {
            let model = try FirebaseEncoder().encode(customer)
            
            let key = ref.childByAutoId().key
            ref.child(key!).setValue(model){ [weak self] (err, resp) in            
                
                guard err == nil else {
                    self?.failureBlock?(DEFAULT_ERROR)
                    return
                }
                
                self?.successBlock?(nil)
            }    
            
        } catch let error {
            print(error)
            failureBlock?(DEFAULT_ERROR)
        }  
    }
    
    public func get() {
        let ref = getDatabaseReference()
        
        ref.observeSingleEvent(of: DataEventType.value, with: {[weak self] (snapshot) in
            guard let value = snapshot.value else { return }
            
            do {                
                let customerList = try FirebaseDecoder().decode([String:CTACustomerModel].self, from: value)
                
                let customerArray : [CTACustomerModel] = customerList.map { $0.value }
                self?.successBlock?(customerArray)
                
            }catch let error {
                print(error)
                self?.failureBlock?(DEFAULT_ERROR)
            }
            
        })
    }
}
