//
//  RegisterViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 08/10/24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: BaseViewController {

    @IBOutlet weak var emailTextfield: CustomInputField!
    @IBOutlet weak var passwordTextfield: CustomInputField!
    @IBOutlet weak var confirmPasswordTextfield: CustomInputField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var coordinator: RegisterCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.setup(title: "Email", placeholder: "input email")
        passwordTextfield.setup(title: "Password", placeholder: "input Password")
        confirmPasswordTextfield.setup(title: "Confirm Password"  , placeholder: "input Re Password")
        
        registerButton.addTarget(self, action: #selector(actionRegister), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(actionLogin), for: .touchUpInside)
    }
    
    @objc func actionLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionRegister() {
        guard let email = emailTextfield.textfield.text, let password = passwordTextfield.textfield.text, let confirmPassword = confirmPasswordTextfield.textfield.text else {
            let popupData = PopUpModel(title: "Error",
                                       description: "Please fill in all fields.",
                                       image: "empty-cart-png",
                                       twoButton: false)
            showCustomPopUp(popupData)
                 return
             }
             
             if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                 let popupData = PopUpModel(title: "Error",
                                            description: "All fields must be filled.",
                                            image: "empty-cart-png",
                                            twoButton: false)
                 showCustomPopUp(popupData)

                 return
             }
             
             if password != confirmPassword {
                 let popupData = PopUpModel(title: "Error",
                                            description: "Passwords do not match.",
                                            image: "empty-cart-png",
                                            twoButton: false)
                 showCustomPopUp(popupData)
                 return
             }
             
             // Firebase Registration
             Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                 if let error = error {
                     self.handleError(error)
                     return
                 }
                 
                 self.addAlert(title: "Sukses", message: "Berhasil membuat akun" ) {
                     let vc = LoginViewController()
                     self.navigationController?.pushViewController(vc, animated: true)
                 }
                 
             }
    }


   

}
