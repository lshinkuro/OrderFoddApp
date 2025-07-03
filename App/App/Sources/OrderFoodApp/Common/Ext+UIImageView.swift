//
//  Ext_UIImageView.swift
//  OrderFoodApp
//
//  Created by Phincon on 10/10/24.
//

import Foundation
import UIKit

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        // Create a data task to fetch the image from the URL
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Check for errors and if data is valid
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error: could not load image from data")
                return
            }
            
            // Update the UIImageView on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume() // Start the data task
    }
}

