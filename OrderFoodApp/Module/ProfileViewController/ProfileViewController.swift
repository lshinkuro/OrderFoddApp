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
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    private var tooltipView: TooltipView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // label
//        titleLabel.text = .localized("welcome_message")
        
        titleLabel.font = UIFont.foodBrownie(24)
        
        /*
        let attrText = NSMutableAttributedString(string: String(format: .localized("welcome"), "ophelia", "6"))
        attrText.addColoredText(color: .foodBrightCoral5, forText: "ophelia")

        // Tetapkan teks berwarna pada label
        titleLabel.attributedText = attrText*/

        // Penggunaan
        let mutableAttributedString = NSMutableAttributedString(string: String(format: .localized("welcome"), "ophelia", "6"))
        mutableAttributedString.applyUnderlineAndStrikethrough(color: .purple, forText: "ophelia")

        
        titleLabel.attributedText = mutableAttributedString

        
        
        // Button
        logoutButton.setTitle(NSLocalizedString("logout_button", comment: "Label for logout button"), for: .normal)
        
        // Alert
        let alert = UIAlertController(
            title: NSLocalizedString("alert_title", comment: "Title of the alert"),
            message: NSLocalizedString("alert_message", comment: "Message in the alert"),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_button", comment: "OK button label"), style: .default))
                
    }
    

    func setup() {
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
