//
//  TodoListViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import UIKit
import CoreData

class TodoListViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    let chartList = ChartList.shared
    
    var vm: ViewModelProtocol = TodoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        setupView()
    }
    
    
    func setupView() {
        addButton.addTarget(self, action: #selector(actionAddButton), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(actionFilterButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(actionResetButton), for: .touchUpInside)
  
        // Mendaftarkan custom UITableViewCell dengan XIB
        let nib = UINib(nibName: "ChartItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChartItemTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func actionAddButton() {
        addShowPersonAlert()
    }
    
    @objc func actionResetButton() {
        vm.isFiltered = false
        FilterStatus.shared.reset()
        self.tableView.reloadData()
    }
    
    @objc func actionFilterButton() {
        let bottomSheetVC = FilterChartItemBottomSheet()
        bottomSheetVC.modalPresentationStyle = .automatic
        
        bottomSheetVC.onApplyFilter = { minAge, maxAge, name in
            var result = self.chartList.dataList
            if let name = name {
                result = result.filter { $0.title.lowercased().contains(name.lowercased()) }
            }
            result = result.filter { $0.age >= minAge && $0.age <= maxAge }
            self.vm.filteredDataList = result
            self.vm.isFiltered = true
            self.tableView.reloadData()
        }
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return 450 // Atur tinggi sheet sesuai keinginan dalam CGFloat
                }
                sheet.detents = [customDetent]
                sheet.largestUndimmedDetentIdentifier = .large
            } else {
                // Fallback on earlier versions
            }
         
        }
        
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.isFiltered ? vm.filteredDataList.count : self.chartList.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartItemTableViewCell", for: indexPath) as? ChartItemTableViewCell else {
            return UITableViewCell()
        }
        
        let data = vm.isFiltered ? vm.filteredDataList[indexPath.row] : chartList.dataList[indexPath.row]
        cell.setup(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        shoewEditAlert(idx: index)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.chartList.removePersonAt(idx: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
}


// MARK: Editing and Add with Alert
extension TodoListViewController {
    
    func addShowPersonAlert() {
        let alertController = UIAlertController(title: "Edit Your Name", message: "Please enter your name below:", preferredStyle: .alert)
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Masukan Name"
        }
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Masukan Umur"
        }
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Masukan Pekerjaan"
        }
        
        // Add an action for "OK" button
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            if let name = alertController?.textFields?[0].text,
               let age = alertController?.textFields?[1].text,
               let pekerjaan = alertController?.textFields?[2].text {
                let person = ChartModel(image: "onboard-1",
                                        title: name,
                                        description: pekerjaan,
                                        age: Int(age) ?? 0)
                self.chartList.addPerson(person: person)
                self.tableView.reloadData()
            }
        }
        
        // Add an action for "Cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    func shoewEditAlert(idx: Int) {
        let alertController = UIAlertController(title: "Edit Your Name", message: "Please enter your name below:", preferredStyle: .alert)
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = self.chartList.dataList[idx].title
        }
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.text = String(self.chartList.dataList[idx].age)
        }
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Pekerjaan"
            textField.text = self.chartList.dataList[idx].description
        }
        
        // Add an action for "OK" button
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            if let name = alertController?.textFields?[0].text,
               let age = alertController?.textFields?[1].text,
               let pekerjaan = alertController?.textFields?[2].text {
                let person = ChartModel(image: "onboard-1",
                                        title: name,
                                        description: pekerjaan ,
                                        age: Int(age) ?? 0)
                self.chartList.editPerson(idx: idx, person: person)
                self.tableView.reloadData()
            }
        }
        
        // Add an action for "Cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
}

