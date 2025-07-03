//
//  ItemPlaceholderTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/10/24.
//

import UIKit

class ItemPlaceholderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var showViewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup() {
        idLabel.textColor = UIColor.random()
        showViewButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc func tapButton() {
        descLabel.isHidden.toggle()
        if descLabel.isHidden {
            showViewButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            showViewButton.tintColor = UIColor.orange
        } else {
            showViewButton.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
            showViewButton.tintColor = UIColor.orange
            
        }
        
        // Notify the table view that updates are about to begin
        if let tableView = self.superview as? UITableView {
            UIView.performWithoutAnimation {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
        //        if let indexPath = tableView?.indexPath(for: self) {
        //           print("Button tapped in cell at section \(indexPath.section), row \(indexPath.row)")
        //           // Do something with the indexPath
        //            delegate?.updateCellHeight(indexPath: indexPath)
        //        }
    }
    
    
    
    func configureData(item: PlaceholderItem?) {
        if let item = item {
            idLabel.text =  String(item.id)
            titleLabel.text = item.title.prefixWords(4)
            descLabel.text =  item.body
        }
    }
    
}

