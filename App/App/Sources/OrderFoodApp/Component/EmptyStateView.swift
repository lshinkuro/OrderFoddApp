//
//  EmptyState.swift
//  OrderFoodApp
//
//  Created by Phincon on 02/10/24.
//

import Foundation
import UIKit



protocol EmptyStateViewDelegate {
    func tapButton()
}

class EmptyStateView: ReusableViewFrame {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    
    var delegate: EmptyStateViewDelegate?
    
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
        tapButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
    }
    
    @objc func actionTap() {
        delegate?.tapButton()
    }
    
    func configureData(desc: String, image: String) {
        imgView.image = UIImage(named: image)
        descLabel.text = desc
    }
}
