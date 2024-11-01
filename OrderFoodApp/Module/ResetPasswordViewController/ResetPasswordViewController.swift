//
//  ResetPasswordViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 11/10/24.
//

import UIKit
import IQKeyboardManagerSwift


class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet private var textfields: [UITextField]!
    @IBOutlet weak var resetPasswordButton: GradientColorButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        textfields.forEach { textField in
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
        }
        
        textfields.forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordTapped), for: .touchUpInside)
        
        updateResetButtonState(isEnabled: false)
    }
    
    @objc private func resetPasswordTapped() {
        let enteredCode = getCodeFromTextFields()
        print("Entered PIN Code: \(enteredCode)")
        
        // Perform verification of the entered code or further action
        verifyCode(enteredCode)
    }
    
    
    // Function to verify the entered code (example)
    private func verifyCode(_ code: String) {
        // Example: Perform code verification here
        if code == "1234" { // Replace with actual verification logic
            print("Code is correct")
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Code is incorrect")
        }
    }
    
    // Function to check if all text fields are filled
    private func areAllFieldsFilled() -> Bool {
        return textfields.allSatisfy { !$0.text!.isEmpty }
    }
    
    private func updateResetButtonState(isEnabled: Bool) {
        resetPasswordButton.isEnabled = isEnabled
        resetPasswordButton.backgroundColor = isEnabled ? UIColor.systemOrange : UIColor.lightGray
        resetPasswordButton.setTitleColor(isEnabled ? UIColor.white : UIColor.gray, for: .normal)
    }
    
}

extension ResetPasswordViewController: UITextFieldDelegate {
    // MARK: - Actions
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Move to next text field if one character has been entered
        if let text = textField.text, text.count >= 1 {
            moveToNextTextField(currentTextField: textField)
        }
        
        let isFormComplete = areAllFieldsFilled()
        updateResetButtonState(isEnabled: isFormComplete)
    }
    
    
    
    private func getCodeFromTextFields() -> String {
        return textfields.reduce("") { (result, textField) -> String in
            return result + (textField.text ?? "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            moveToPreviousTextField(currentTextField: textField)
            return false
        }
        
        if let text = textField.text, text.count >= 1 {
            textField.text = string
            moveToNextTextField(currentTextField: textField)
            return false
        }
        
        return true
    }
    
    private func moveToNextTextField(currentTextField: UITextField) {
        if let index = textfields.firstIndex(of: currentTextField), index < textfields.count - 1 {
            let nextTextField = textfields[index + 1]
            nextTextField.becomeFirstResponder()
        } else {
            currentTextField.resignFirstResponder()
        }
    }
    
    private func moveToPreviousTextField(currentTextField: UITextField) {
        if let index = textfields.firstIndex(of: currentTextField), index > 0 {
            // Get the previous text field
            let previousTextField = textfields[index - 1]
            // Set the current text field text to empty
            currentTextField.text = ""
            // Move focus to the previous text field
            previousTextField.becomeFirstResponder()
            // Check if the form is complete after the change
            let isFormComplete = areAllFieldsFilled()
            updateResetButtonState(isEnabled: isFormComplete)
        } else {
            // If the current text field is the first one, just clear its text and resign keyboard
            currentTextField.text = ""
            currentTextField.resignFirstResponder()
        }
    }
}
