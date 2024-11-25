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
import Lottie
import Speech

class MapKitViewController: BaseViewController {
    
    @IBOutlet weak var mapkitView: MKMapView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var targetButton: UIButton!
    
    
    // Setup tableview untuk menampilkan hasil
    let tableView = UITableView()
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    // Tambahkan properti
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    
    private var micAnimationView: LottieAnimationView!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id-ID"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocation()
        setupSearchCompleter()
        setupMicButton()
        requestSpeechAuthorization()
        
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
    
    private func setupMicButton() {
        
        micButton.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        
        micAnimationView = LottieAnimationView(name: "loading")
        micAnimationView.contentMode = .scaleAspectFit
        micAnimationView.loopMode = .loop
        micAnimationView.isHidden = true
        view.addSubview(micAnimationView)
        
        micAnimationView.snp.makeConstraints { make in
            make.edges.equalTo(micButton)
        }
    }
    
    @objc private func micButtonTapped() {
        if SFSpeechRecognizer.authorizationStatus() == .authorized {
            if audioEngine.isRunning {
                 audioEngine.stop()
                 recognitionRequest?.endAudio()
                 micButton.isEnabled = false
                 micButton.setImage(UIImage(systemName: "mic"), for: .normal)
                 micAnimationView.stop()
                 micAnimationView.isHidden = false
                 print("Mic button tapped: stopping recording and hiding animation")
             } else {
                 startRecording()
                 micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
                 micAnimationView.isHidden = true
                 micAnimationView.play()
                 print("Mic button tapped: starting recording and showing animation")
             }
        } else {
            requestSpeechAuthorization()
        }
    }
    
    private func showSpeechRecognitionSettings() {
        let alertController = UIAlertController(
            title: "Speech Recognition Access Required",
            message: "In order to use voice input, please enable Speech Recognition in Settings.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error setting up audio session: \(error)")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create recognition request")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                self.searchTextfield.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                searchCompleter.queryFragment = result.bestTranscription.formattedString
                shouldShowReference(status: true)
            }
            
            if error != nil || isFinal {
                DispatchQueue.main.async {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.micButton.isEnabled = true
                    self.micButton.setImage(UIImage(systemName: "mic"), for: .normal)
                    self.micAnimationView.stop()
                    self.micAnimationView.isHidden = true
                    
                    print("Speech recognition ended, animation should be hidden now")
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
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
        
        //        mapkitView.mapType = .standard // Default 2D
        mapkitView.mapType = .satellite // View satelit
        //        mapkitView.mapType = .hybrid
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapkitView.addGestureRecognizer(tapGesture)
        searchTextfield.delegate = self
    }
    
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.micButton.isEnabled = true
                case .denied:
                    self.micButton.isEnabled = false
                    print("User denied access to speech recognition")
                    self.showSpeechRecognitionSettings()
                case .restricted:
                    self.micButton.isEnabled = false
                    print("Speech recognition restricted on this device")
                case .notDetermined:
                    self.micButton.isEnabled = false
                    print("Speech recognition not yet authorized")
                @unknown default:
                    return
                }
            }
        }
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
            
            let destinationCoordinate = mapkitView.convert(locationInView, toCoordinateFrom: mapkitView)
            
            // Panggil rute dari lokasi pengguna ke koordinat yang dipilih
            if let userLocation = locationManager.location {
                calculateRoute(from: userLocation.coordinate, to: destinationCoordinate)
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

extension MapKitViewController: UITextFieldDelegate, MKLocalSearchCompleterDelegate {
    
    func setupSearchCompleter() {
        searchCompleter.delegate = self
//        searchCompleter.resultTypes = .address
        searchCompleter.region = mapkitView.region // Optional: batasi area pencarian
        searchTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func textFieldDidChange() {
        guard let searchText = searchTextfield.text else { return }
        shouldShowReference(status: !searchText.isEmpty)
        guard !searchText.isEmpty else { return }
        searchCompleter.queryFragment = searchText
    }
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        shouldShowReference(status: true)
    }
        
    // Delegate method untuk hasil pencarian
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.isHidden = searchResults.isEmpty
        // Reload tableview dengan hasil
        tableView.reloadData()
    }
    
    func shouldShowReference(status: Bool) {
        switch status {
        case true:
            if !view.subviews.contains(tableView) {
                view.addSubview(tableView)
                tableView.snp.makeConstraints {
                    $0.horizontalEdges.equalToSuperview().inset(20)
                    $0.top.equalTo(searchTextfield.snp.bottom).offset(10)
                    $0.height.equalTo(400)
                }
                tableView.makeCornerRadius(16)
            } else {
                tableView.isHidden = false
            }
        case false:
            if view.subviews.contains(tableView) {
                tableView.isHidden = true
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search error: \(error.localizedDescription)")
    }
    
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


// Extension untuk TableView
extension MapKitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") ?? UITableViewCell()
        let result = searchResults[indexPath.row]
        let searchText = searchTextfield.text ?? ""
        // Menggunakan extension
        cell.textLabel?.attributedText = result.title.highlightText(searchText)
        cell.detailTextLabel?.text = result.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        
        // Lakukan pencarian detail lokasi
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            guard let mapItem = response?.mapItems.first else { return }
            
            // Set region ke lokasi yang dipilih
            let coordinate = mapItem.placemark.coordinate
            self.setRegion(longitude: coordinate.longitude, latitude: coordinate.latitude)
        }
        
        // Sembunyikan tableview
        tableView.isHidden = true
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func calculateRoute(from sourceCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) {
        // Hapus overlay rute sebelumnya jika ada
        mapkitView.removeOverlays(mapkitView.overlays)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .automobile // Bisa diganti .walking, .transit dll
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error calculating route: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            
            // Tambahkan rute ke peta
            self.mapkitView.addOverlay(route.polyline)
            
            // Zoom ke area rute
            self.mapkitView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            // Tambahkan delegate method untuk menggambar rute
            // Di extension MKMapViewDelegate
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
