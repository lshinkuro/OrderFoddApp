//
//  BaseHostingTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 06/02/25.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit

class BaseHostingTableViewCell<Content: View>: UITableViewCell {
    private var hostingController: UIHostingController<Content>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with swiftUIView: Content, parentViewController: UIViewController) {
        if hostingController == nil {
            hostingController = UIHostingController(rootView: swiftUIView)
            guard let hostingController = hostingController else { return }
            
            parentViewController.addChild(hostingController)
            contentView.addSubview(hostingController.view)
            
            hostingController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            hostingController.didMove(toParent: parentViewController)
        } else {
            hostingController?.rootView = swiftUIView
        }
    }
}

