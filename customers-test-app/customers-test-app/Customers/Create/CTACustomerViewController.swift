//
//  CTACustomerViewController.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 11/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import MaterialComponents.MaterialSnackbar
import CodableFirebase

class CTACustomerViewController: CTABaseViewController {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var birthdateDatePicker: UIDatePicker!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var facebookLoginService : CTAFacebookLoginService!
    var viewModel : CTACustomerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registar cliente"
        
        facebookLoginService = CTAFacebookLoginService()
        facebookLoginService.signOutDelegate = self
        
        loadUserInfo()
        setupTextFields()
        profilePhoto.setCornerRadiusAndBorder()
        
        viewModel = CTACustomerViewModel()
        viewModel.delegate = self
        
        //TODO Mover esto a un controller para popular una collectionView
//        var ref: DatabaseReference!
//        ref = Database.database().reference().child("customers")
//        
//        ref.observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
//            guard let value = snapshot.value else { return }
//            
//            do {
//                
//                let customerList = try FirebaseDecoder().decode([String:CustomerModel].self, from: value)
//                
//                let customerArray : [CustomerModel] = customerList.map { $0.value }
//                print(customerArray)
//                
//            }catch let error {
//                print("ERROR: \(error)")
//            }
//            
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(show: true)
        showBackButton(show: false)
    }
    
    private func setupTextFields() {
        nameTextField.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 1)
        lastnameTextField.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 1)
        ageTextField.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 1)
    }
    
    private func loadUserInfo() {          
        if let currentUser = facebookLoginService.getCurrentUser() {
            if let displayName = currentUser.displayName {
                name.text = displayName
            }
            
            if let photoUrl = currentUser.photoURL?.absoluteString {
                profilePhoto.setImage(imageUrl: photoUrl)
            }
        }
    }
    
    private func cleanFields(){
        nameTextField.text = EMPTY_STRING
        lastnameTextField.text = EMPTY_STRING
        ageTextField.text = EMPTY_STRING
        birthdateDatePicker.date = Date.init()
    }
    
    @IBAction func onSave(_ sender: Any) {
        let birthdate = birthdateDatePicker.date
        let name = nameTextField.text
        let lastname = lastnameTextField.text
        let age = ageTextField.text
        
        viewModel.save(name: name, lastname: lastname, age: age, birthdate: birthdate)
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        facebookLoginService.signOut()
    }
}

// MARK CTASignOutDelegate

extension CTACustomerViewController : CTASignOutDelegate {
    func onSignOut() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK CTACustomerViewModelDelegate

extension CTACustomerViewController : CTACustomerViewModelDelegate {
    func onRequiredField(message: String) {
        errorMessageLabel.text = message
    }
    
    func onSaveSuccess(message: String) {
        errorMessageLabel.text = EMPTY_STRING
        CTASnackbarHelper.showMessage(message: message)
        cleanFields()
    }
    
    func onSaveError(message: String) {
        errorMessageLabel.text = EMPTY_STRING
        CTASnackbarHelper.showMessage(message: message)
    }
}
