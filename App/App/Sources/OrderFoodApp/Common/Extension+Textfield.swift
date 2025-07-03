//
//  Extension+Textfield.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import Foundation
import UIKit

private var passwordVisibleKey: UInt8 = 0

extension UITextField {
    func setDefaultPlaceholder(placeholder: String, hexColor: String) {
        // Mengatur border pada UITextField
        self.layer.borderWidth = 1.0 // Ketebalan border
        self.layer.borderColor = UIColor(hex: hexColor).cgColor // Warna border
        self.layer.cornerRadius = 16.0 // Radius sudut
        self.layer.masksToBounds = true // Memastikan border terpotong pada radius sudut
        // Membuat UIView untuk spasi di kiri
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))

        // Mengatur leftView dari textField dengan paddingView
        self.leftView = paddingView
        self.leftViewMode = .always  // Menampilkan leftView selalu
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor:  UIColor(hex: "#979797")] // Ganti warna sesuai kebutuhan
        )
        
    }
    
    
    // Fungsi untuk menambahkan tombol show/hide password
    func addRightView(imgString: String, toggleAction: @escaping () -> Void) {
        // Tambahkan tombol di sebelah kanan
        self.isSecureTextEntry = true // Default untuk menyembunyikan password
        let showPasswordButton = UIButton(type: .custom)
        let eyeImage = UIImage(systemName: imgString)?.withRenderingMode(.alwaysTemplate).withTintColor(.foodGrey4) // Set rendering mode
        showPasswordButton.tintColor = .foodGrey4 // Ubah warna tint menjadi hitam
        showPasswordButton.setImage(eyeImage, for: .normal)
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        showPasswordButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // Tambahkan padding untuk jarak dari kanan
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)) // Tambahkan padding
        paddingView.addSubview(showPasswordButton)
        showPasswordButton.center = paddingView.center
        
        self.rightView = paddingView
        self.rightViewMode = .always
        
        // Store the action as a closure
        objc_setAssociatedObject(self, &passwordVisibleKey, toggleAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc func buttonTapped() {
        if let action = objc_getAssociatedObject(self, &passwordVisibleKey) as? () -> Void {
            action() // Panggil closure untuk toggle password visibility
        }
    }
    
    func setupRightButton(button: UIButton) {
        button.frame = CGRect(x: 12, y: 12, width: 20, height: 20)
        
        let containerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        containerView.addSubview(button)
        
        rightView = containerView
        rightViewMode = .always
    }
    
}


// Extension untuk mengonversi warna hex menjadi UIColor
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func random() -> UIColor {
          return UIColor(
              red: CGFloat.random(in: 0...1),
              green: CGFloat.random(in: 0...1),
              blue: CGFloat.random(in: 0...1),
              alpha: 1.0
          )
      }
}



