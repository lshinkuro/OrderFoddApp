//
//  CustomInputField.swift
//  OrderFoodApp
//
//  Created by Phincon on 03/10/24.
//

import UIKit
import SwiftUI


class CustomInputField: ReusableViewXIB {

    @IBOutlet weak var textfieldLabel: UILabel!
    @IBOutlet weak var texfieldContainerView: FormView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var logoImgView: UIImageView!
    
    //MARK: use load nibs if setting by programatically
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configView()
    }
    
    func configView() {
        textfieldLabel.text = "username"
        textfield.placeholder = "masukan nama mu"
        errorLabel.isHidden = true
        logoImgView.isHidden = true
    }
    
    func setup(title: String, placeholder: String) {
        textfieldLabel.text = title
        textfield.placeholder = placeholder
    }
}
