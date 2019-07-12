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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("user loged with google")
        })
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        } 
        
        if let accesssToken = AccessToken.current?.tokenString {
            let credential = FacebookAuthProvider.credential(withAccessToken: accesssToken)
            
            Auth.auth().signIn(with: credential, completion: {(authResult, error) in 
                guard error == nil else {
                    print(error!.localizedDescription)
                    return 
                }
                
                if let email = authResult?.user.email {
                    print(email)
                    var ref: DatabaseReference!
                    ref = Database.database().reference().child("users")
                    
                    let key = ref.childByAutoId().key
                    let customer = ["username": "usuarioPrueba"]
                    
                    
                    ref.child(key!).setValue(customer){ (err, resp) in
                        guard err == nil else {
                            print("Posting failed : ")
                            print(err?.localizedDescription)
                            
                            return
                        }
                        print("No errors while posting, :")
                        print(resp)
                    }                    
                    //                    ref.child("TZhMCBDY4PyPUDyTJONQ").setValue(["username" : authResult?.user.displayName])
                    //                    let newCustomer = ref.childByAutoId()
                    //                    newCustomer.updateChildValues(["username" : ])
                    
                    
                    //                    guard let key = ref.childByAutoId().key else { return }
                    //                    let customer = ["username": authResult?.user.displayName]
                    //                    let udpates = ["/users/\(key)": customer]
                    //                    
                    //                    ref.updateChildValues(udpates)
                    
                } else {
                    print("email is empty")
                }
            })
            
        }else {
            print("Token error")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logout")
    }
    
}

