//
//  SpecialForYouTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/10/24.
//

import UIKit

class SpecialForYouTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: SelfSizingTableView!
    @IBOutlet weak var heighTableView: NSLayoutConstraint!
    
    
    var specialData: [FoodItem] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        updateTableViewHeight()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        heighTableView.constant = tableView.contentSize.height
        tableView.reloadData()
    }
    
    
    func setup() {
        selectionStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(SpecialItemTableViewCell.self)
        
        // Set estimasi height cell
        tableView.rowHeight = UITableView.automaticDimension
        
        // Penting: Set ini agar table view bisa grow sesuai content
        tableView.isScrollEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension SpecialForYouTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SpecialItemTableViewCell
        //        heighTableView.constant = tableView.contentSize.height
        return cell
    }
    
    
}


class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

