//
//  ExampleMapKitViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 22/01/25.
//

import UIKit
import MapKit
import CoreLocation

class ExampleMapKitViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Minta izin lokasi
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Tampilkan lokasi pengguna di MapView
        mapView.showsUserLocation = true
        
        let coordinate = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
        addPinToMap(coordinate: coordinate, title: "Jakarta", subtitle: "Ibu Kota Indonesia")
        
        navigateToLocation(latitude: -6.2088, longitude: 106.8456)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        addPinToMap(coordinate: coordinate, title: "Lokasi Baru", subtitle: "")
    }
    
    func addPinToMap(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    
    
    
}

extension ExampleMapKitViewController: CLLocationManagerDelegate {
    // Delegate untuk menangani update lokasi
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        
        // Zoom ke lokasi pengguna
        let region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "custom_pin_image")
            annotationView?.canShowCallout = true

            // Tambahkan button di callout
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    func navigateToLocation(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = "Tujuan Saya"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

