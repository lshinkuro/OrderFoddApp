//
//  ChartItemTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit

class ChartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = UIColor.random()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: ChartModel?) {
        guard let data = data else { return }
        self.imgView.image = UIImage(named: data.image)
        self.nameLabel.text = "Nama : \(data.title)"
        self.ageLabel.text = "Umur: \(data.age)"
        self.statusLabel.text = "Work: \(data.description)"
    }
    
    func configure(data: ToDoItem?) {
        guard let data = data else { return }
        self.imgView.image = UIImage(named: "onboard_1")
                                     
        self.nameLabel.text = "title : \(data.title)"
        self.ageLabel.text = "duration: \(data.duration)"
        self.statusLabel.text = "description: \(data.description)"
    }
    
}
