//
//  CTABaseViewController.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 13/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit

class CTABaseViewController: UIViewController {

    public func showNavigationBar(show: Bool){
        navigationController?.setNavigationBarHidden(!show, animated: true)
    }
    
    public func showBackButton(show: Bool){
        navigationController?.navigationBar.topItem?.title = show ? EMPTY_STRING : title
        navigationItem.hidesBackButton = !show        
    }
}
