//
//  ProfileViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.configureSound("ph_intro")
        self.navigationItem.setTitleNav(title: "Profile")
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(3, for: .default)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
