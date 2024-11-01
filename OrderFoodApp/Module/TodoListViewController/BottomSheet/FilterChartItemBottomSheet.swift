//
//  FilterChartItemBottomSheet.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit

class FilterStatus {
    static let shared = FilterStatus()
    private init() {}
    
    var minAge: Int = 0
    var maxAge: Int = 100
    var name: String?
    
    func reset() {
        self.minAge = 0
        self.maxAge = 100
        self.name = nil
    }
}

class FilterChartItemBottomSheet: UIViewController {
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var minageLabel: UILabel!
    @IBOutlet weak var maxageLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var minAgeSlider: UISlider!
    @IBOutlet weak var maxAgeSlider: UISlider!
    
    // closure yang akan di panggil ketika filterButton di click
    var onApplyFilter: ((_ minAge: Int, _ maxAge: Int, _ name: String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedFilter()
    }
    
    func setupUI() {
        
        containerView.makeCornerRadius(26, maskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        searchTextfield.setDefaultPlaceholder(placeholder: "Cari Nama", hexColor: "#979797")
        
        
        minAgeSlider.minimumValue = 0
        minAgeSlider.maximumValue = 30
        minAgeSlider.value = 20
        minAgeSlider.addTarget(self, action: #selector(ageSliderChanged(_:)), for: .valueChanged)
        
        maxAgeSlider.minimumValue = 30
        maxAgeSlider.maximumValue = 100
        maxAgeSlider.value = 31
        maxAgeSlider.addTarget(self, action: #selector(ageSliderChanged(_:)), for: .valueChanged)
        filterButton.addTarget(self, action: #selector(applyFilterButtonTapped(_:)), for: .touchUpInside)
    }
    
    func loadSavedFilter() {
        // Load previously saved filter from FilterStatus
        let filterStatus = FilterStatus.shared
        maxAgeSlider.value = Float(filterStatus.maxAge)
        maxageLabel.text = "Max Age: \(filterStatus.maxAge)"
        
        minAgeSlider.value = Float(filterStatus.minAge)
        minageLabel.text = "Min Age: \(filterStatus.minAge)"
        searchTextfield.text = filterStatus.name
    }
    
    @objc func ageSliderChanged(_ sender: UISlider) {
        if sender == maxAgeSlider {
            let selectedAge = Int(sender.value)
            maxageLabel.text = "Max Age: \(selectedAge)"
        }
        
        if sender == minAgeSlider {
            let selectedAge = Int(sender.value)
            minageLabel.text = "Min Age: \(selectedAge)"
        }
    }
    
    @objc func applyFilterButtonTapped(_ sender: UIButton) {
        
        let minAge = Int(minAgeSlider.value)
        let maxAge = Int(maxAgeSlider.value)
        let name = searchTextfield.text?.isEmpty == true ? nil : searchTextfield.text
        
        // Save the filter settings in the singleton
        FilterStatus.shared.minAge = minAge
        FilterStatus.shared.maxAge = maxAge
        FilterStatus.shared.name = name
        
        onApplyFilter?(minAge, maxAge, name)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
