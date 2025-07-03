//
//  ExampleCryptoKitViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 28/10/24.
//

import UIKit
import CryptoKit


class ExampleCryptoKitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testEncrypt()

        // Do any additional setup after loading the view.
    }


    func testEncrypt() {
        let symetricKey = SymmetricKey(size: .bits256)
        if  let plainText = "hello , world".data(using: .utf8) {
            do {
                let encryptData = try AES.GCM.seal(plainText, using: symetricKey)
                print("encrypt data : \(encryptData)")
                
                let decryptData = try AES.GCM.open(encryptData, using: symetricKey)
                let decryptString = String(data: decryptData, encoding: .utf8)
                
                print("decrypt data : \(String(describing: decryptString))")

            } catch {
                print("error \(error)")
            }
        }
        
     
    }

}
