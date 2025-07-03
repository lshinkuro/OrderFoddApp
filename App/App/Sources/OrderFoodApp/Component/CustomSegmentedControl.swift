//
//  CustomSegmentedControl.swift
//  OrderFoodApp
//
//  Created by Phincon on 23/10/24.
//

import Foundation
import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
         // Set the corner radius for the entire control
         self.layer.cornerRadius = 30
         self.layer.masksToBounds = true
         self.backgroundColor = .white
         
         // Update the selection view frame on initial load
         
         // Set default appearance for segments
         self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
         self.setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .selected)
       
     }
     
}
