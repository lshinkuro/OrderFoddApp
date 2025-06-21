//
//  CoachmarkManualVC.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/01/25.
//

import Foundation
import UIKit


class CoachmarkManualVC: UIViewController {
    
    private let tableView = UITableView()
    private var coachMark: CoachMarks?
    
    private var isFirstLaunch = true // Menandakan apakah ini pertama kali halaman dibuka

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Konfigurasi tampilan
        setupTableView()
        setupNavigationBar()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)

          // Tampilkan Coach Mark hanya pada pertama kali masuk
          if isFirstLaunch {
//              isFirstLaunch = false
              startCoachMark()
          }
      }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Table View Example"
    }
    
    func startCoachMark() {
        coachMark = CoachMarks(on: tableView)
        
        // Tentukan elemen-elemen yang akan disorot
        var steps: [(CGRect, String)] = []
        
        // Header section pertama
        if let headerView = tableView.headerView(forSection: 0) {
            let headerFrame = headerView.convert(headerView.bounds, to: view)
            steps.append((headerFrame, "Ini adalah header section pertama."))
        }
        
        // Cell pertama di section pertama
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            let cellFrame = cell.convert(cell.bounds, to: view)
            steps.append((cellFrame, "Ini adalah cell pertama di section pertama."))
        }
        
        
        // Cell pertama di section pertama
        if let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) {
            let cellFrame = cell.convert(cell.bounds, to: view)
            steps.append((cellFrame, "Ini adalah cell empat di section pertama."))
        }
        
        coachMark?.setSteps(steps)
        coachMark?.start()
    }
}

// MARK: - UITableViewDataSource
extension CoachmarkManualVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section + 1)"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CoachmarkManualVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
