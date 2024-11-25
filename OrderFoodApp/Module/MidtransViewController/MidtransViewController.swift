//
//  MidtransViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 08/11/24.
//

import UIKit
import MidtransKit

class MidtransViewController: BaseViewController {
    var token: String?
    private var paymentViewController: MidtransUIPaymentViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        requestTransactionToken()
        
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(handlePaymentStatusUpdated(_:)),
               name: Notification.Name("PaymentStatusUpdated"),
               object: nil
           )
    }

    // MARK: - Payment Methods
    private func requestTransactionToken() {
        MidtransMerchantClient.shared().requestTransacation(
            withCurrentToken: token ?? ""
        ) { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let response = response {
                DispatchQueue.main.async {
                    // Create and store payment view controller
                    self.paymentViewController = MidtransUIPaymentViewController(token: response)
                    
                    // Ensure delegate is set before presenting
                    if let paymentVC = self.paymentViewController {
                        paymentVC.paymentDelegate = self
                        
                        // Present the payment view controller
                        self.present(paymentVC, animated: true) {
                            print("Payment view controller presented successfully")
                        }
                    } else {
                        print("Failed to initialize payment view controller")
                    }
                }
            } else if let error = error {
                print("Transaction token request failed: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - MidtransUIPaymentViewControllerDelegate
extension MidtransViewController: MidtransUIPaymentViewControllerDelegate {
    
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentPending result: MidtransTransactionResult!) {
        print("Payment pending - Order ID: \(result.orderId ?? "unknown")")
        if let transactionResult = result {
            print("Payment pending - Order ID: \(transactionResult.orderId ?? "unknown")")
            dismiss(animated: true) {
                self.handlePaymentStatus(status: "pending", result: transactionResult)
                
            }
        } else {
            print("Payment pending - Result is nil")
        }
    }

    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentDeny result: MidtransTransactionResult!) {
        print("Payment denied - Order ID: \(result.orderId ?? "unknown")")
        dismiss(animated: true) {
            // Handle denied payment state
            self.handlePaymentStatus(status: "denied", result: result)
        }
    }

    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentSuccess result: MidtransTransactionResult!) {
        print("Payment success - Order ID: \(result.orderId ?? "unknown")")
        if let transactionResult = result {
            print("Payment Success - Order ID: \(transactionResult.orderId ?? "unknown")")
            print("payment cuk \(transactionResult)")
            dismiss(animated: true) {
                self.handlePaymentStatus(status: "Success", result: transactionResult)
            }
        } else {
            print("Payment Succes - Result is nil")
        }
    }

    func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: Error!) {
        print("Payment failed: \(error.localizedDescription)")
        dismiss(animated: true) {
            // Handle failed payment state
            self.handlePaymentError(error: error)
        }
    }

    func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
        print("Payment cancelled by user")
        dismiss(animated: true) {
            // Handle cancelled payment state
            self.handlePaymentStatus(status: "cancelled", result: nil)
        }
    }
    
    // MARK: - Helper Methods
    private func handlePaymentStatus(status: String, result: MidtransTransactionResult?) {
        // Add your custom handling logic here
        let orderId = result?.orderId ?? "unknown"
        let transactionStatus = result?.transactionStatus ?? "unknown"
        
        print("Payment Status: \(status)")
        print("Order ID: \(orderId)")
        print("Transaction Status: \(transactionStatus)")
        
        
        
        // Post notification for payment status update if needed
        NotificationCenter.default.post(
            name: Notification.Name("PaymentStatusUpdated"),
            object: nil,
            userInfo: [
                "status": status,
                "orderId": orderId,
                "transactionStatus": transactionStatus
            ]
        )
    }
    
    
    @objc private func handlePaymentStatusUpdated(_ notification: Notification) {
        // Pastikan data tersedia
        guard let userInfo = notification.userInfo,
              let status = userInfo["status"] as? String,
              let orderId = userInfo["orderId"] as? String,
              let transactionStatus = userInfo["transactionStatus"] as? String else {
            print("Data not complete")
            return
        }
        
        // Lakukan sesuatu dengan data
        print("Payment status: \(status)")
        print("Order ID: \(orderId)")
        print("Transaction Status: \(transactionStatus)")
        
        if transactionStatus == "capture" || transactionStatus == "settlement" {
            print("Pembayaran berhasil")
        } else if transactionStatus == "pending" {
            print("Menunggu pembayaran")
            // Kembali ke tab bar index 0
            self.tabBarController?.selectedIndex = 0

            // Reset navigation controller untuk tab bar index 1 ke root view controller
            if let navigationController = self.tabBarController?.viewControllers?[1] as? UINavigationController {
                navigationController.popToRootViewController(animated: false)
            }
        } else {
            print("Transaksi gagal: \(transactionStatus)")
        }
    }
    
    private func handlePaymentError(error: Error) {
        // Add your custom error handling logic here
        print("Payment Error: \(error.localizedDescription)")
        
        // Post notification for payment error if needed
        NotificationCenter.default.post(
            name: Notification.Name("PaymentError"),
            object: nil,
            userInfo: ["error": error]
        )
    }
}
