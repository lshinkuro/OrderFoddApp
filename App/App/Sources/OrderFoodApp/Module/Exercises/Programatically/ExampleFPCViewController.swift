//
//  ExampleFPCViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 23/10/24.
//

import UIKit
import RxSwift

class ExampleFPCViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    public var heightFPC = CustomObservable<CGFloat>()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightFPC.observer = getHeightOfViewController()

    }

    private func getHeightOfViewController() -> CGFloat {
        let totalHeight = containerView.frame.height + 30
        return totalHeight
    }

}
