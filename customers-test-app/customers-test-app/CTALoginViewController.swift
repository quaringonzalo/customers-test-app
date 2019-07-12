//
//  ViewController.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 10/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class CTALoginViewController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["email"]
    
        let image = UIImage(named: "cta_login_background")
        
        view.backgroundColor = UIColor(patternImage: image!)
        
        Auth.auth().addStateDidChangeListener({ [weak self] (auth, user)  in
            if user != nil {
                let customerViewController = CTACustomerViewController()
                self?.navigationController?.pushViewController(customerViewController, animated: true)
            }
        })
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        } 
        
        if let accesssToken = AccessToken.current?.tokenString {
            let credential = FacebookAuthProvider.credential(withAccessToken: accesssToken)

            
            Auth.auth().signIn(with: credential, completion: { [weak self] (authResult, error) in 
                guard error == nil else {
                    print(error!.localizedDescription)
                    return 
                }
                
                self?.saveCustomer(authResult)
                
            })
            
        }else {
            print("Token error")
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logout")
    }
    
    private func saveCustomer(_ authResult: AuthDataResult?) {
        if let email = authResult?.user.email {
            print(email)
            var ref: DatabaseReference!
            ref = Database.database().reference().child("users")
            
            let key = ref.childByAutoId().key
            let customer = ["username": authResult!.user.email]
            
            
            ref.child(key!).setValue(customer){ (err, resp) in
                guard err == nil else {
                    print("Posting failed : ")
                    print(err?.localizedDescription as Any)
                    
                    return
                }
                print("No errors while posting, :")
                print(resp)
            }                    
            
        } else {
            print("email is empty")
        }
    }
    
}

