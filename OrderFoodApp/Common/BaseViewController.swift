//
//  BaseViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import Foundation
import UIKit
import AVFoundation
import FirebaseAuth
import IQKeyboardManagerSwift
import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboard()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let welcomeMessage = RemoteConfigManager.shared.versionApp
        let generalBC = RemoteConfigManager.shared.generalBackroundColor
        
        
        print("Welcome Message: \(welcomeMessage)")
        print("generalBC: \(generalBC)")
        view.backgroundColor = UIColor(hex: generalBC)
    }
    
    func showCustomPopUp(_ data: PopUpModel?) {
        let vc = CustomPopUpViewController()
        vc.popUpData = data
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func configureSound(_ audioName: String, type: String = "mp3") {
        guard let path = Bundle.main.path(forResource: audioName, ofType: type) else { return }
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("error")
        }
        player?.play()
    }
    
    func handleError(_ error: Error) {
        let nsError = error as NSError
        var errorMessage = "Login failed. Please try again."
        
        // Handle specific Firebase errors
        if let errorCode = AuthErrorCode(rawValue: nsError.code) {
            switch errorCode {
            case .invalidEmail:
                errorMessage = "Invalid email format."
            case .wrongPassword:
                errorMessage = "Incorrect password."
            case .userNotFound:
                errorMessage = "No account found with this email."
            case .networkError:
                errorMessage = "Network error. Please try again."
            case .userDisabled:
                errorMessage = "This account has been disabled."
            default:
                errorMessage = error.localizedDescription
            }
        }
        
        
        let popupData = PopUpModel(title: "Error",
                                   description: errorMessage,
                                   image: "empty-cart-png",
                                   twoButton: false)
        showCustomPopUp(popupData)
    }
    
    func addAlert(title: String, message: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an action for "OK" button
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showCustomPIN(completion: (() -> Void)? = nil) {
        let alertVC = CustomPinViewController()
        
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.onCorrectPINEntered = {
            self.dismiss(animated: true) {
                completion?()
            }
        }
        present(alertVC, animated: true, completion: nil)
    }
    
    func configureKeyboard() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = false
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = .foodBlack80
    }
    
}
