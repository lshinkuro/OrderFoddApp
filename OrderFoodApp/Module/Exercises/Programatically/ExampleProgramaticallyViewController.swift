//
//  ExampleProgramaticallyViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 22/10/24.
//

import UIKit

class ExampleProgramaticallyViewController: UIViewController {
    
    let boxView: UIView =  {
        let view = UIView()
        view.backgroundColor = .green
        view.makeCornerRadius(20)
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Halo"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let boxView2: UIView =  {
        let view = UIView()
        view.backgroundColor = .red
        view.makeCornerRadius(20)
        return view
    }()
    
    let labelOne: UILabel = {
         let label = UILabel()
         label.text = "Label One"
         label.textColor = .white
         label.textAlignment = .center
         return label
     }()
     
     let labelTwo: UILabel = {
         let label = UILabel()
         label.text = "Label Two"
         label.textColor = .white
         label.textAlignment = .center
         return label
     }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal  // Bisa diubah ke .horizontal jika ingin horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureData()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        boxView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        boxView2.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(boxView)
        view.addSubview(boxView2)
        boxView.addSubview(textLabel)
        boxView2.addSubview(stackView)
        
        stackView.addArrangedSubview(labelOne)
        stackView.addArrangedSubview(labelTwo)

        
        NSLayoutConstraint.activate([
            boxView.widthAnchor.constraint(equalToConstant: 200),
            boxView.heightAnchor.constraint(equalToConstant: 200),
            boxView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -16),
            textLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 10),
            textLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -10),
            
            /*textLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),*/
            
            boxView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boxView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            boxView2.topAnchor.constraint(equalTo: boxView.bottomAnchor, constant: 10),
            boxView2.heightAnchor.constraint(equalToConstant: 200),
            
            stackView.centerXAnchor.constraint(equalTo: boxView2.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: boxView2.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: boxView2.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: boxView2.trailingAnchor, constant: -20)
        ])
    
    }
    
    func configureData() {
        textLabel.text = "Halo indonesia , selamat tahun baru 2025"
    }
    

    

}
