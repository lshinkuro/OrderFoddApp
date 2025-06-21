//
//  CustomHeaderSectionCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 04/10/24.
//

import Foundation
import UIKit
import SwiftUI

struct CustomHeaderSectionCell_Previews: PreviewProvider {
    static var previews: some View {
        previewView(CustomHeaderSectionCell())
            .frame(width: 100, height: 50) // Atur ukuran tampilan
    }
}


class CustomHeaderSectionCell: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(hex: "979797")
        label.text = "Section Header"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
        
        // Tambahkan subview
        addSubview(imageView)
        addSubview(label)
        
        // Atur layout menggunakan frame
        let headerHeight: CGFloat = 60
        let imageSize: CGFloat = 40
        imageView.frame = CGRect(x: 16, y: (headerHeight - imageSize) / 2, width: imageSize, height: imageSize)
        let labelX = imageView.frame.maxX + 16
        label.frame = CGRect(x: labelX, y: 0, width: frame.width - labelX - 16, height: headerHeight)
    }
    
    // Method untuk mengkonfigurasi view dengan data
    func configure(with imageName: String, title: String) {
        imageView.image = UIImage(named: imageName)
        label.text = title
    }
}
