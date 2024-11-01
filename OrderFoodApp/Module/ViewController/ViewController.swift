//
//  ViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Create a view with multi-layer progress bars
        let multiProgressView = MultiCircularProgressView(frame: CGRect(x: (self.view.bounds.width/2) - 150 , y: 200, width: 300, height: 300))
            view.addSubview(multiProgressView)
            
            // Animate the progress over 2.5 seconds
            multiProgressView.animateProgress(duration: 2.5)
        setup()
    }
    
    func setup() {
        nextButton.addTarget(self, action: #selector(actionNextButton(_:)), for: .touchUpInside)
    }
    
    @objc func actionNextButton(_ sender: UIButton) {
        
        if sender == nextButton {
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}
