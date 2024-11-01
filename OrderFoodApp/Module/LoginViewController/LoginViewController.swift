//
//  LoginViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var usernameField: CustomInputField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordVield: CustomInputField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    let viewModel = LoginViewModel()
    lazy var loadingIndicator = PopUpLoading(on: view)
    
    var coordinator: LoginCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindingData()
    }
    
    
    func bindingData() {
        viewModel.onUpdateItem = { [weak self] response in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if let token = response.data.token.accessToken {
                self.storeTokenInKeychain(token)
                DispatchQueue.main.async {
                    self.showMainAppScreen()
                }
            }
            
        }
        
        viewModel.onLoading = { [weak self] loading in
            guard let self = self else { return }
            guard let loading = loading else { return }
            DispatchQueue.main.async {
                switch loading {
                case .loading:
                    print("loading")
                    self.loadingIndicator.show()
                case .failed:
                    print("gagal request")
                    self.loadingIndicator.dismissAfter1()
                case .finished:
                    print("selesai request")
                    self.loadingIndicator.dismissAfter1()
                default:
                    break
                }
            }
        }
        
    }
    
    func setup() {
        
        usernameField.setup(title: "Username"  , placeholder: "input Nama")
        passwordVield.setup(title: "Password"  , placeholder: "input Password")
        
        
        loginButton.addTarget(self,
                              action: #selector(actionNextButton(_:)),
                              for: .touchUpInside)
        registerButton.addTarget(self,
                                 action: #selector(actionNextButton(_:)),
                                 for: .touchUpInside)
        
        forgotPassword.addTarget(self,
                                 action: #selector(actionNextButton(_:)),
                                 for: .touchUpInside)
        
        passwordVield.textfield.addRightView(imgString: "eye.fill") { [weak self] in
            self?.togglePasswordVisibility()
        }
    }
    
    func togglePasswordVisibility() {
        passwordVield.textfield.isSecureTextEntry.toggle()
        let eyeImage = passwordVield.textfield.isSecureTextEntry ? UIImage(systemName: "eye.fill")?.withTintColor(.foodGrey3) : UIImage(systemName: "eye.slash.fill")?.withTintColor(.foodGrey3)
        
        
        if let rightView = passwordVield.textfield.rightView,
           let showPasswordButton = rightView.subviews.compactMap({ $0 as? UIButton }).first {
            showPasswordButton.setImage(eyeImage, for: .normal)
        }
    }
    
    @objc func actionNextButton(_ sender: UIButton) {
        
        if sender == loginButton {
            //logicLogin()
            logicLogin()
        } else if sender == registerButton {
            self.coordinator?.showRegister()
        } else {
            let vc = ResetPasswordViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func logicLoginByeAPI() {
        guard let email = usernameField.textfield.text, let password = passwordVield.textfield.text else {
            let popupData = PopUpModel(title: "Error",
                                       description: "Please enter both email and password.",
                                       image: "empty-cart-png",
                                       twoButton: false)
            showCustomPopUp(popupData)
            return
        }
        // Pemanggilan API
        let param = LoginParam(username: email, password: password)
        viewModel.requestData(param: param)
    }
    
    func logicLogin() {
        guard let email = usernameField.textfield.text, let password = passwordVield.textfield.text else {
            let popupData = PopUpModel(title: "Error",
                                       description: "Please enter both email and password.",
                                       image: "empty-cart-png",
                                       twoButton: false)
            showCustomPopUp(popupData)
            return
        }
        
        if email.isEmpty || password.isEmpty {
            let popupData = PopUpModel(title: "Error",
                                       description: "Email and password must not be empty.",
                                       image: "empty-cart-png",
                                       twoButton: false)
            showCustomPopUp(popupData)
            return
        }
        
        // Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.handleError(error)
                return
            }
            
            guard let user = authResult?.user else { return }
            
            // Get Firebase Auth token and store it in Keychain
            user.getIDToken { token, error in
                if let error = error {
                    let popupData = PopUpModel(title: "Error",
                                               description:"Failed to retrieve token: \(error.localizedDescription)",
                                               image: "empty-cart-png",
                                               twoButton: false)
                    self.showCustomPopUp(popupData)
                    return
                }
                
                FAM.shared.logButtonEvent(buttonName: "loginButton",screenName: "LoginScreen")
                
                if let token = token {
                    self.storeTokenInKeychain(token)
                    print("Firebase token: \(token)")  // Debugging
                    //                    self.showMainAppScreen()
                    self.coordinator?.showHomeScreen()
                }
            }
        }
    }
    
    func storeTokenInKeychain(_ token: String) {
        let tokenData = Data(token.utf8)
        KeychainHelper.shared.save(tokenData, forKey: KeychainHelperKey.firebaseAuthToken)
    }
    
    // Function to show main screen after successful login
    func showMainAppScreen() {
        AppSettings.shared.isFirstTime = false
        let tabbar = MainTabBarController()
        self.navigationController?.pushViewController(tabbar, animated: true)
    }
}
