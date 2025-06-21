//
//  CustomProfileInputFieldWithIcon.swift
//  OrderFoodApp
//
//  Created by Phincon on 19/03/25.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class CustomProfileInputFieldWithImage: CustomProfileInputField {
    
    lazy var button = UIButton().configure {
        $0.isSelected = false
    }
    
    private let iconImageView = UIImageView()
    
    init(title: String,
         placeholder: String,
         imageName: String,
         text: BehaviorRelay<String> = .init(value: ""),
         onButtonClicked: (() -> ())? = nil) {
        super.init(title: title, placeholder: placeholder, text: text)
            self.setupUI()
            self.bind(imageName: imageName, onButtonClicked: onButtonClicked)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        textField.setupRightButton(
            button: button
        )
    }
    
    func bind(imageName: String, onButtonClicked: (() -> ())? = nil) {
        button.setImage(
            UIImage(
                systemName: imageName
            ),
            for: .normal
        )
        
        button.addTapGestureAction {
            onButtonClicked?()
        }
    }
    
    
}
