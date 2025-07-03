//
//  HistoryOrderViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit

class HistoryOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // Variable to store the previously selected segment
    var previousSelectedSegmentIndex: Int = 0
    
    var currentOrderData: [FoodItem] = [] // Array untuk data table view
    let completeOrders: [FoodItem] = foodData[1].items
    let pendingOrders: [FoodItem] = foodData[0].items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentOrderData = completeOrders
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellWithNib(FoodChartItemTableViewCell.self)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    
    func hideNavigationBar(){
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = true
        self.hidesBottomBarWhenPushed = false
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex
        var direction: CATransitionSubtype
        
        // Determine direction based on previous and current segment index
        if currentSegmentIndex > previousSelectedSegmentIndex {
            direction = .fromRight
        } else {
            direction = .fromLeft
        }        
        updateTableView(with: sender.selectedSegmentIndex, direction: direction)
        previousSelectedSegmentIndex = currentSegmentIndex

    }
    
    // Fungsi TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOrderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FoodChartItemTableViewCell
        
        cell.configureHistory(with: currentOrderData[indexPath.row], quantity: 4)
        return cell
    }
    
    func updateTableView(with selectedIndex: Int, direction: CATransitionSubtype) {
        // Update data sesuai dengan segmen yang dipilih
        if selectedIndex == 0 {
            currentOrderData = completeOrders
        } else {
            currentOrderData = pendingOrders
        }
        
        // Buat transisi
        let transition = CATransition()
        transition.type = .push
        transition.subtype = direction
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Tambahkan animasi transisi ke tableView
        tableView.layer.add(transition, forKey: "tableViewTransition")
        
        // Reload tableView data dengan animasi
        tableView.reloadData()
    }
    
}
