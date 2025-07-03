//
//  SenderViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 24/10/24.
//

import UIKit


extension Notification.Name {
    static let NotifData = Notification.Name("NotificationData")
}

class SenderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func sendNotification(_ sender: Any) {
        let data: [String: Any] = ["message": "hello, world" ]
        NotificationCenter.default.post(name: .NotifData, object: data)
    }
 

}
