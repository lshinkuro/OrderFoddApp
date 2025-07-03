//
//  MixSwiftUIViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/10/24.
//

import Foundation
import SnapKit
import UIKit
import SwiftUI
import CoreLocation

class MixSwiftUIViewController: UIViewController {
    
    
    let locationManager = CLLocationManager()
    private var hostingController: UIHostingController<ListView>!
    
    private let foods = [
        ListItem(name: "Nasi Goreng", price: 25000, description: "Nasi goreng spesial dengan telur dan ayam"),
        ListItem(name: "Mie Goreng", price: 23000, description: "Mie goreng dengan sayuran segar"),
        ListItem(name: "Sate Ayam", price: 30000, description: "Sate ayam dengan bumbu kacang")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
        setup()
    }
    
    func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Meminta izin saat aplikasi digunakan
        locationManager.requestWhenInUseAuthorization()
        
        // Untuk memulai pembaruan lokasi
        locationManager.startUpdatingLocation()
    }
    
    private func setupSwiftUIView() {
        let foodListView = ListView(foods: foods) { [weak self] selectedFood in
            self?.handleFoodSelection(food: selectedFood)
        }
        
        hostingController = UIHostingController(rootView: foodListView)
        
        // Add as child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func handleFoodSelection(food: ListItem) {
        // Handle food selection here
        print("Selected food: \(food.name)")
        // Contoh: Menampilkan alert ketika item dipilih
        let alert = UIAlertController(
            title: "Food Selected",
            message: "\(food.name)\nPrice: Rp \(food.price)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MixSwiftUIViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Izin lokasi belum ditentukan.")
        case .restricted, .denied:
            print("Izin lokasi ditolak.")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Izin lokasi diberikan.")
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Lokasi saat ini: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
    }
}
