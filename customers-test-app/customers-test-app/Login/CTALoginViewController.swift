//
//  ViewController.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 10/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class CTALoginViewController: UIViewController {
    
    let loginBackgroundImage = "cta_login_background"
    var facebookLoginDelegate : CTAFacebookLoginService!
    
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginDelegate = CTAFacebookLoginService()
        facebookLoginDelegate.signIndelegate = self
        facebookLoginDelegate.addLoginListener()
        
        fbLoginButton.delegate = facebookLoginDelegate
        
        let image = UIImage(named: loginBackgroundImage)
        view.backgroundColor = UIColor(patternImage: image!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }    
}

//MARK CTALoginDelegate

extension CTALoginViewController : CTASignInDelegate {
    func onSignIn() {
        let customerViewController = CTACustomerViewController()
        navigationController?.pushViewController(customerViewController, animated: true)
    }
}

