//
//  MapKitViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/11/24.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import IQKeyboardManagerSwift

class MapKitViewController: BaseViewController {

    @IBOutlet weak var mapkitView: MKMapView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var targetButton: UIButton!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocation()
    }

    
    func setupView() {
        
        searchButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else {return}
            guard let address = self.searchTextfield.text else {
                // Handle the case where the text field is empty
                return
            }

            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }

                if let placemark = placemarks?.first {
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    self.setRegion(longitude: coordinate?.longitude, latitude: coordinate?.latitude)
                }
            }
        }.disposed(by: disposeBag)
        
        targetButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else {return}
            self.locationManager.startUpdatingLocation()
        }.disposed(by: disposeBag)
        
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapkitView.delegate = self


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapkitView.addGestureRecognizer(tapGesture)
        searchTextfield.delegate = self
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let locationInView = gestureRecognizer.location(in: mapkitView)
            let coordinate = mapkitView.convert(locationInView, toCoordinateFrom: mapkitView)
            print("Latitude cuy: \(coordinate.latitude), Longitude cuy: \(coordinate.longitude)")

            geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placemarks, error) in
                  if let error = error {
                      print("Reverse geocoding error: \(error.localizedDescription)")
                      return
                  }

                  if let placemark = placemarks?.first {
                      if let city = placemark.locality, let village = placemark.subLocality {
                          print("City: \(city), Village: \(village)")
                          let annotation = CustomAnnotation(coordinate: coordinate, title: city, subtitle: village)
                          self.mapkitView.addAnnotation(annotation)
                      }
                  }
              }
        }
    }

    
    func setRegion(longitude: Double? = 0.0 , latitude: Double? = 0.0) {
        print("Latitude: \(latitude ?? 0.0), Longitude: \(longitude ?? 0.0)")
        // Center the map around the specified coordinates

        let center = CLLocationCoordinate2D(latitude: latitude ?? 0.0 , longitude: longitude ?? 0.0)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
        self.mapkitView.setRegion(region, animated: true)
    }

}

extension MapKitViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.setRegion(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension MapKitViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when "Return" key is pressed
        textField.resignFirstResponder()

        // Perform your action here
        if let text = textField.text {
            geocoder.geocodeAddressString(text) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }

                if let placemark = placemarks?.first {
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    self.setRegion(longitude: coordinate?.longitude, latitude: coordinate?.latitude)
                }
            }
        }

        return true
    }

}

extension MapKitViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
              return nil // Return nil to use the default blue dot for user location
          }

          let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
          annotationView.tintColor = .blue // Customize the pin color
          annotationView.canShowCallout = true
          annotationView.animatesWhenAdded = true // Animate the pin drop

          let detailButton = UIButton(type: .detailDisclosure)
          annotationView.rightCalloutAccessoryView = detailButton

          return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
          // Handle the accessory control tap event (e.g., show more details)
          if let customAnnotation = view.annotation as? CustomAnnotation {
              print("Tapped Custom Annotation at Latitude: \(customAnnotation.coordinate.latitude), Longitude: \(customAnnotation.coordinate.longitude)")
          }
      }
}

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
