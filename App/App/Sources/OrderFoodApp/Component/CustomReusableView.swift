//
//  CustomReusableView.swift
//  OrderFoodApp
//
//  Created by Phincon on 03/10/24.
//

import Foundation
import UIKit


extension UIView {
    func setNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
}

class ReusableViewXIB: UIView {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: use load nibs if setting in XIB override uiview
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .clear
        self.addSubview(view)
    }
}

class ReusableViewFrame: UIView {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .clear
        self.addSubview(view)
    }
    
    //MARK: use load nibs if setting in XIB override uiview
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
