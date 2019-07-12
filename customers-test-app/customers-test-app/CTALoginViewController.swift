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
import GoogleSignIn

class CTALoginViewController: UIViewController, LoginButtonDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["email"]
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func onLogout(_ sender: Any) {
        do {
            try 
                Auth.auth().signOut()
                GIDSignIn.sharedInstance().signOut()
                GIDSignIn.sharedInstance().disconnect()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { [weak self] (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self?.saveCustomer(authResult)
        })
        
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

