//
//  ErrorView.swift
//  OrderFoodApp
//
//  Created by Phincon on 13/10/24.
//

import UIKit

protocol ErrorViewDelegate {
    func tapButton()
}

class ErrorView: ReusableViewFrame {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    
    var delegate: ErrorViewDelegate?

    //MARK: use load nibs if setting by programatically
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    func configureView() {
        errorButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
    }
    
    @objc func actionTap() {
        delegate?.tapButton()
    }
    
    func configureData(desc: String, image: String) {
        imgView.image = UIImage(named: image)
        errorLabel.text = desc
    }
  
}
