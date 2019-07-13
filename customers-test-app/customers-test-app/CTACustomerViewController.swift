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

//TODO mover a un archivo
public struct CustomerModel : Codable {
    let name: String
    let lastname: String
    let age: Int
    let birthdate: String
}

class CTACustomerViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var birthdateDatePicker: UIDatePicker!
    
    @IBAction func onSave(_ sender: Any) {
        
        
        //TODO: Agregar validación de datos requeridos
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        //Validación de datos opcionales
        let birthdate = dateFormatter.string(from: birthdateDatePicker.date)
        let name = nameTextField.text!
        let lastname = lastnameTextField.text!
        let age = Int(ageTextField.text!)!
        
        
        //TODO Revisart en proyecto de github firebase
        var ref: DatabaseReference!
        ref = Database.database().reference().child("customers")
        
        let key = ref.childByAutoId().key
        let customer = CustomerModel(name: name, lastname: lastname, age: age, birthdate: birthdate)
//        let customer = ["name": name,
//                        "lastname": lastname,
//                        "age": age,
//                        "birthdate": birthdate]
        
        
        do {
            let model = try FirebaseEncoder().encode(customer)
            ref.child(key!).setValue(model){ (err, resp) in            
                guard err == nil else {
                    print("Posting failed : \(err?.localizedDescription as Any)")
                    return
                }
                
                //TODO mover esto a una función
                let message = MDCSnackbarMessage(text: "Los datos se guardaron correctamente")
                MDCSnackbarManager.show(message)
                
                //TODO Función para limpiar los campos
                
            }    
            
        } catch let error {
            print(error)
        }               
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Registar cliente"
        
        
        photo.layer.borderWidth = 1
        photo.layer.masksToBounds = false
        photo.layer.borderColor = UIColor.gray.cgColor
        photo.layer.cornerRadius = photo.layer.frame.height / 2
        photo.clipsToBounds = true
        
        
        let url = URL(string: (Auth.auth().currentUser?.photoURL?.absoluteString)!)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async() {
                self.photo.image = UIImage(data: data!)
            }
        }).resume()
        
        name.text = Auth.auth().currentUser?.displayName
        
        //Crear una extensión de textfield para hacer esto
        nameTextField.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 1)
        lastnameTextField.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 1)
        ageTextField.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 1)
        
        
        //TODO Mover esto a un controller para popular una collectionView
        var ref: DatabaseReference!
        ref = Database.database().reference().child("customers")
        
        ref.observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
            guard let value = snapshot.value else { return }
            
            do {
                
                let customerList = try FirebaseDecoder().decode([String:CustomerModel].self, from: value)
                
                let customerArray : [CustomerModel] = customerList.map { $0.value }
                print(customerArray)
                
            }catch let error {
                print("ERROR: \(error)")
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try 
            
            Auth.auth().signOut()
            LoginManager().logOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//TODO Mover a otra clase
extension UIView {
    
    enum LINE_POSITION {
        case LINE_POSITION_TOP
        case LINE_POSITION_BOTTOM
    }
    
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}
