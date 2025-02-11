//
//  TableViewLanjutanViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 24/01/25.
//

import UIKit

class TableViewLanjutanViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = [
        ["Apple", "Banana", "Orange"], // Section 0
        ["Carrot", "Potato"],          // Section 1
        ["Chicken", "Fish"]           // Section 2
    ]
    
    // data bentuk dictionary
    let dataDict = [
        "Fruits": ["Apple", "Banana", "Orange"],
        "Vegetables": ["Carrot", "Potato"],
        "Proteins": ["Chicken", "Fish"]
    ]
    
    let sectionTitles = ["Fruits", "Vegetables", "Proteins"]

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    func addSection() {
        let newSection = ["Item 1", "Item 2"]
        data.append(newSection) // Tambah data
        tableView.beginUpdates()
        tableView.insertSections(IndexSet(integer: data.count - 1), with: .automatic)
        tableView.endUpdates()
    }

    func removeSection(at index: Int) {
        guard index < data.count else { return }
        data.remove(at: index) // Hapus data
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(integer: index), with: .automatic)
        tableView.endUpdates()
    }
    
    func addRows(section: Int) {
        data[section].insert("New Item", at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
    }

}


extension TableViewLanjutanViewController: UITableViewDataSource, UITableViewDelegate {

    
 
    // jumlah section di dalam table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        
        let label = UILabel()
        label.text = sectionTitles[section] // Jika menggunakan dictionary
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.frame = CGRect(x: 16, y: 5, width: tableView.frame.width, height: 30)
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Tinggi header
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 // Tinggi footer
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    

    
    
    
}
