//
//  QRCodeScanViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/10/24.
//

import UIKit
import AVFoundation
import SnapKit

class QRCodeScanViewController: BaseViewController {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var holeView: UIView!
    
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    var onBarcodeDetected: ((String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        setupOverlayView()
    }
    
    deinit {
        
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showCustomPopUp(PopUpModel(title: "Error", description: "Camera tidak tersedia", image: "ads1"))
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            showCustomPopUp(PopUpModel(title: "Error", description: "Error accessing camera: \(error.localizedDescription)", image: "ads1"))
            
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            showCustomPopUp(PopUpModel(title: "Error", description: "Tidak dapat menambahkan input camera", image: "ads1"))
            return
        }
        
        // Tambahkan metadata output untuk membaca barcode
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            // Set delegate dan dispatch queue
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set tipe barcode yang ingin dibaca
            metadataOutput.metadataObjectTypes = [
                .ean8,          // Barcode EAN-8
                .ean13,         // Barcode EAN-13
                .pdf417,        // PDF417
                .qr,            // QR Code
                .code39,        // Code 39
                .code93,        // Code 93
                .code128,       // Code 128
                .aztec,         // Aztec
                .dataMatrix,    // Data Matrix
                .interleaved2of5, // ITF
                .upce          // UPC-E
            ]
            
            // Set scan area
            metadataOutput.rectOfInterest = CGRect(
                x: 0.2, // Margin kiri 20%
                y: 0.2, // Margin atas 20%
                width: 0.6, // Lebar area 60%
                height: 0.6 // Tinggi area 60%
            )
        } else {
            showCustomPopUp(PopUpModel(title: "Error", description: "Tidak dapat menambahkan output metadata", image: "ads1"))
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Mulai capture session di background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    private func setupOverlayView() {
        
        // Menambahkan overlay view ke tampilan
        //          view.addSubview(overlayView)
        
        // Mengatur batasan overlayView
        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Menambahkan holeView ke overlayView
        overlayView.addSubview(holeView)
        
        // Mengatur batasan holeView agar berada di tengah overlayView
        holeView.snp.remakeConstraints {
            $0.width.height.equalTo(200) // Ukuran lubang
            $0.center.equalToSuperview()   // Memposisikan di tengah
        }
        
        // Membuat efek lubang
        let holePath = UIBezierPath(rect: holeView.frame)
        let path = UIBezierPath(rect: overlayView.bounds)
        path.append(holePath)
        path.usesEvenOddFillRule = true
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillRule = .evenOdd
        overlayView.layer.mask = shapeLayer
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

extension QRCodeScanViewController:AVCaptureMetadataOutputObjectsDelegate {
    // Implement AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        // Check if we have at least one object
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            
            // Play haptic feedback
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Stop scanning
            captureSession.stopRunning()
            
            // Handle the scanned value
            DispatchQueue.main.async { [weak self] in
                self?.handleScannedCode(stringValue)
            }
        }
    }
    
    private func handleScannedCode(_ code: String) {
        // Callback dengan hasil scan
        onBarcodeDetected?(code)
        
        // Tampilkan alert dengan hasil scan
        let alert = UIAlertController(
            title: "Barcode Detected",
            message: "Value: \(code)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Resume scanning after alert is dismissed
            DispatchQueue.global(qos: .background).async {
                self?.captureSession.startRunning()
            }
        })
        
        present(alert, animated: true)
    }
}
