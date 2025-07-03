//
//  ToolBarView.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import Foundation
import UIKit
import SwiftUI


//@available(iOS 13.0, *)
//struct ViewController_Previews: PreviewProvider {
//    static var previews: some View {
//      previewView(ToolBarView()).previewLayout(.sizeThatFits)
//    }
//}

class ToolBarView: ReusableViewXIB {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        leftButton.addTarget(self, action: #selector(actionleftButton), for: .touchUpInside)
    }
    
    @objc func actionleftButton() {
        // Pop view controller
      if let viewController = self.getViewController() {
          viewController.navigationController?.popViewController(animated: true)
      }
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
}
