//
//  ProfileViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit
import RxSwift
import SnapKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var tooltipBtn: UIButton!
    
    private var tooltipView: TooltipView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tooltipBtn.rx.tap.subscribe{ [weak self] _ in
            guard let self = self else { return }
            TooltipManager.shared.showTooltip(text: "This is a helpful tooltip!" ,
                                              near: tooltipBtn,
                                              in: self,
                                              position: .top,
                                              trianglePosition: .left
            )
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.configureSound("ph_intro")
        self.navigationItem.setTitleNav(title: "Profile")
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(3, for: .default)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
