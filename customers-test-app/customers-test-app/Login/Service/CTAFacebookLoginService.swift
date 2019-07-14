//
//  CTAFacebookLoginDelegate.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 13/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

public protocol CTASignInDelegate : class {
    func onSignIn()
}

public protocol CTASignOutDelegate : class {
    func onSignOut()
}

public class CTAFacebookLoginService: NSObject, LoginButtonDelegate {
    
    public weak var signIndelegate: CTASignInDelegate!
    public weak var signOutDelegate: CTASignOutDelegate!
    
    public func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        guard error == nil else {
            CTASnackbarHelper.showMessage(message: error!.localizedDescription)
            return
        } 
        
        if let accesssToken = AccessToken.current?.tokenString {
            let credential = FacebookAuthProvider.credential(withAccessToken: accesssToken)
            
            Auth.auth().signIn(with: credential, completion: {(authResult, error) in 
                guard error == nil else {
                    CTASnackbarHelper.showMessage(message: error!.localizedDescription)
                    return 
                }                
            })
            
        }else {
            CTASnackbarHelper.showMessage(message: "Ocurrió un error. Intente nuevamente")
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logout")
    }
    
    public func signOut(){
        do {
            try Auth.auth().signOut()
            
            LoginManager().logOut()
            signOutDelegate.onSignOut()
        } catch let signOutError as NSError {
            CTASnackbarHelper.showMessage(message: String(format: "Error signing out: %@", signOutError))
        }
    }
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func addLoginListener(){
        Auth.auth().addStateDidChangeListener({ [weak self] (auth, user)  in
            if user != nil {
                self?.signIndelegate.onSignIn()
            }
        })
    }
}
