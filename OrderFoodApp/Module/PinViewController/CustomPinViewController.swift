//
//  CustomPinViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 10/10/24.
//

import UIKit

struct PINConstants {
    static let maxDigits = 4
    static let maxAttempts = 3
    static let lockoutTime: TimeInterval = 30
}

enum ContainerColors {
    static let defaultColor = UIColor.clear
    static func color(forDigit digit: Int) -> UIColor {
        return UIColor(red: CGFloat(digit) / 10.0, green: 0.7, blue: 0.9, alpha: 1.0)
    }
}

class CustomPinViewController: BaseViewController {
    
    
    @IBOutlet private var digitsContainer: [UIView]!
    @IBOutlet private var numbersButton: [UIButton]!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var correctPIN: String = ""
    
    private var enteredDigits: [Int] = [] {
        didSet {
            checkPinOnCoreData()
        }
    }
    
    private var attempts = 0
    private var isLockedOut = false
    private var countdownTimer: Timer?
    private var remainingLockoutTime = 0
    private var areButtonsEnabled = true
    
    var onCorrectPINEntered: (() -> Void)?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButtonActions()
        makeButtonsCircular()
        makeContainersCircular()
        enableDisableButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPinOnCoreData()
    }
    
    private func checkPinOnCoreData() {
        descriptionLabel.text = "masukan pin anda untuk proses lebih lanjut"
        
        for (index, container) in digitsContainer.enumerated() {
            container.backgroundColor = enteredDigits.count > index ? ContainerColors.color(forDigit: enteredDigits[index]) : ContainerColors.defaultColor
        }
        
        deleteButton.isEnabled = !enteredDigits.isEmpty
        
        if enteredDigits.count == PINConstants.maxDigits {
            let enteredPIN = enteredDigits.map { String($0) }.joined()
            correctPIN = enteredPIN
            self.dismiss(animated: true)
        }
    }
    
    private func handleIncorrectPIN() {
        attempts += 1
        if attempts >= PINConstants.maxAttempts {
            isLockedOut = true
            startLockoutTimer()
        }
        let remainingAttempts = PINConstants.maxAttempts - attempts
        //showAlert(message: "Incorrect PIN. \(remainingAttempts) attempts remaining.")
        print("Incorrect PIN \(remainingAttempts)")
        enteredDigits.removeAll()
        updateContainerColors()
        digitsContainer.forEach { $0.backgroundColor = UIColor.red }
    }
    
    private func startLockoutTimer() {
        remainingLockoutTime = Int(PINConstants.lockoutTime)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLockoutTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateLockoutTimer() {
        remainingLockoutTime -= 1
        if remainingLockoutTime <= 0 {
            countdownTimer?.invalidate()
            countdownTimer = nil
            attempts = 0
            isLockedOut = false
            areButtonsEnabled = true
            enableDisableButtons()
        } else {
            areButtonsEnabled = false
            enableDisableButtons()
            print("Too many failed attempts. Please try again after")
        }
    }
    
    private func updateContainerColors() {
        guard !isLockedOut else {
            digitsContainer.forEach { $0.backgroundColor = UIColor.red }
            return
        }
        
        for (index, container) in digitsContainer.enumerated() {
            container.backgroundColor = enteredDigits.count > index ? ContainerColors.color(forDigit: enteredDigits[index]) : ContainerColors.defaultColor
        }
        
        
        deleteButton.isEnabled = !enteredDigits.isEmpty
        
        if enteredDigits.count == PINConstants.maxDigits {
            let enteredPIN = enteredDigits.map { String($0) }.joined()
            
            if enteredPIN == correctPIN {
                print("Sukses PIN")
            } else {
                handleIncorrectPIN()
            }
        }
    }
    
    private func setupButtonActions() {
        for button in numbersButton {
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = .foodRed1
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        sender.backgroundColor = .foodRed4
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let digit = Int(sender.titleLabel?.text ?? "") else { return }
        
        if enteredDigits.count < PINConstants.maxDigits {
            enteredDigits.append(digit)
        }
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        if !enteredDigits.isEmpty {
            enteredDigits.removeLast()
            updateContainerColors()
            numbersButton.forEach { $0.backgroundColor = UIColor.orange }
        }
    }
    
    private func makeContainersCircular() {
        let views: [UIView] = digitsContainer
        
        for view in views {
            view.layer.cornerRadius = view.frame.size.width / 2.0
            view.clipsToBounds = true
        }
    }
    
    private func makeButtonsCircular() {
        let buttons: [UIButton] = [deleteButton] + numbersButton
        
        for button in buttons {
            button.layer.cornerRadius = button.frame.size.width / 2.0
            button.clipsToBounds = true
        }
        
        deleteButton.isEnabled = !enteredDigits.isEmpty
    }
    
    private func enableDisableButtons() {
        for button in numbersButton {
            button.isEnabled = areButtonsEnabled
        }
        deleteButton.isEnabled = areButtonsEnabled && !enteredDigits.isEmpty
    }



}
