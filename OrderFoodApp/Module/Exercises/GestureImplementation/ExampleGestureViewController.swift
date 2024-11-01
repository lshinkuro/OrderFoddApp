//
//  ExampleGestureViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 10/10/24.
//

import UIKit

struct AnimalModel {
    let name: String
    let image: String
}

let animalList: [AnimalModel] = [ .init(name: "kucing", image: "kucing"),
                                  .init(name: "kambing", image: "kambing"),
                                  .init(name: "singa", image: "singa"),
                                  .init(name: "kerbau", image: "kerbau"),
                                  .init(name: "sapi", image: "sapi"),
                                  .init(name: "kucing", image: "kucing")]

class ExampleGestureViewController: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var animalPicker: UIPickerView!
    @IBOutlet weak var imgView: UIImageView!
    
    
    let years = Array(1900...2024) // Range of years
    let months = Array(1...12) // 12 months
    var days = Array(1...31) // Initially 31 days (will change based on month)

    var selectedYear = 2022
    var selectedMonth = 1
    var selectedDay = 1
    
    let dataAnimals = animalList
    var selectedAnimal: AnimalModel = .init(name: "kucing", image: "kucing")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    func setup() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Select current date by default
        let currentYearIndex = years.firstIndex(of: selectedYear) ?? 0
        pickerView.selectRow(currentYearIndex, inComponent: 0, animated: true)
        pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: true)
        pickerView.selectRow(selectedDay - 1, inComponent: 2, animated: true)
        
        animalPicker.delegate = self
        animalPicker.dataSource = self
        animalPicker.selectRow(0, inComponent: 0, animated: true)
        
        containerView.makeCornerRadius(26, maskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        if let imageURL = URL(string: "https://plus.unsplash.com/premium_photo-1698505302992-da6c434bd9d5?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D") {
            imgView.loadImage(from: imageURL)
        }
    }
    
    
}

extension ExampleGestureViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case self.pickerView:
            return 3
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerView:
            if component == 0 {
                return years.count
            } else if component == 1 {
                return months.count
            } else {
                return days.count
            }
        default:
            return dataAnimals.count
        }
        
    }
    
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerView:
            if component == 0 {
                return "\(years[row])"
            } else if component == 1 {
                return "\(months[row])"
            } else {
                return "\(days[row])"
            }
        default:
            return "\(dataAnimals[row])"
        }
    }
    
    
    // Customize the view for each row in the picker
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        switch pickerView {
        case self.pickerView:
            let isSelected = row == pickerView.selectedRow(inComponent: component)
            let text: String
            
            // Determine text based on the component
            switch component {
            case 0:
                text = "\(years[row])"
            case 1:
                text = "\(months[row])"
            case 2:
                text = "\(days[row])"
            default:
                return UIView()
            }
            
            // Create and return the custom view
            return CustomPickerRowView(frame: CGRect(x: 0, y: 0, width: 100, height: 50), text: text, isSelected: isSelected)
            
        default:
            let label = UILabel()
            label.textAlignment = .center
            label.text = "\(dataAnimals[row].name)"
            
            // Customize the font and color
            label.font = .foodBrownie(24)
            label.textColor = .foodWhite100
            
            // Highlight the currently selected row (hover effect simulation)
            if row == pickerView.selectedRow(inComponent: component) {
                label.textColor = .foodRed5
                label.font = .foodBrownie(26)
            }
            
            return label
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerView:
            if component == 0 {
                selectedYear = years[row]
            } else if component == 1 {
                selectedMonth = months[row]
            } else {
                selectedDay = days[row]
            }
            
            updateDaysInMonth()
            
            let originalDateString = "\(selectedYear)-\(selectedMonth)-\(selectedDay)" // 2021-12-11
            let newFormat = "dd MMMM yyyy" // Desired format: e.g., 08 October 2024
            let convertedDate = originalDateString.convertDateFormat(from: "yyyy-MM-dd", to: newFormat)
            dateLabel.text = "Converted Date: \(convertedDate)"
        default:
            selectedAnimal =  dataAnimals[row]
            dateLabel.text = "Hewan pilihan : \(selectedAnimal.name)"
            imgView.image = UIImage(named: selectedAnimal.image)
        }
    }
    
    // Update days based on the selected month and year
    func updateDaysInMonth() {
        let isKabisat = (selectedYear % 4 == 0 && selectedYear % 100 != 0) || (selectedYear % 400 == 0)
        
        
        if selectedMonth == 2 {
            days = isKabisat ? Array(1...29) : Array(1...28)
        } else if [4, 6, 9, 11].contains(selectedMonth) {
            days = Array(1...30)
        } else {
            days = Array(1...31)
        }
        
        // Reload the day component when the days change
        pickerView.reloadComponent(2)
        if selectedDay > days.count {
            selectedDay = days.count
        }
        pickerView.selectRow(selectedDay - 1, inComponent: 2, animated: true)
    }
    
}

extension ExampleGestureViewController {
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func handleTap() {
        showCustomPopUp(PopUpModel(title: "Test", description: "Gesture Tap", image: ""))
    }
    
    
    
    func setupSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .left
        containerView.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe() {
        print("View was swiped right!")
        UIView.animate(withDuration: 0.5, animations: {
            self.containerView.frame.origin.x -= 100
        })
    }
    
    func setupPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        containerView.addGestureRecognizer(pinchGesture)
        
        
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        // Adjust the scale of the view
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0  // Reset the scale
    }
    
    func setupPanGesture() {
        // Create a pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        // Move the view with the finger
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        
        // Reset the translation to zero after each move
        gesture.setTranslation(.zero, in: self.view)
    }
    
    
    func setupLongGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        containerView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("Long press began")
            containerView.backgroundColor = .yellow
        } else if gesture.state == .ended {
            print("Long press ended")
            containerView.backgroundColor = .green
        }
    }
    
    
    func setupRotationGesture() {
        
        // Create a rotation gesture recognizer
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        containerView.addGestureRecognizer(rotationGesture)
    }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        // Rotate the view
        view.transform = view.transform.rotated(by: gesture.rotation)
        
        // Reset the rotation to avoid compounding rotations
        gesture.rotation = 0
    }
}



class CustomPickerRowView: UIView {
    
    // The label that will show the data
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .foodBrownie(26)
        return label
    }()
    
    // Initializer
    init(frame: CGRect, text: String, isSelected: Bool) {
        super.init(frame: frame)
        self.setupView(text: text, isSelected: isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up the custom view
    private func setupView(text: String, isSelected: Bool) {
        // Set the background color and corner radius
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        
        // Configure the label's text
        label.text = text
        
        // Adjust the frame of the label inside the view
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width - 40, height: 50)
        label.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        // Update label appearance if selected
        if isSelected {
            label.textColor = .foodGrey1
            label.font = .foodBrownie(26)
        }
        
        // Add the label to the custom view
        self.addSubview(label)
    }
}
