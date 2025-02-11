import Foundation
import UIKit
import AVFoundation
import Vision
import CoreML


class YoloViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
    private var deviceInput: AVCaptureDeviceInput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var rootLayer: CALayer?
    private var bufferSize = CGSize.zero
    private var detectionOverlay: CALayer = {
        let layer = CALayer()
        layer.name = "DetectionOverlay"
        return layer
    }()
    
    // Inisialisasi langsung visionModel dengan YOLOv3
    private let visionModel: VNCoreMLModel = {
        do {
            let model = try YOLOv3(configuration: .init()).model
            return try VNCoreMLModel(for: model)
        } catch {
            fatalError("Failed to load YOLOv3 model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        rootLayer = view.layer
        setupCamera()
    }
    
    private func setupCamera() {
        guard let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
            print("Could not create video device input")
            return
        }
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480
        
        guard session.canAddInput(deviceInput!) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput!)
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        
        do {
            try videoDevice.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions(videoDevice.activeFormat.formatDescription)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        session.commitConfiguration()
        setupPreviewLayer()
        DispatchQueue.main.async {
            self.session.startRunning()
        }
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        view.layer.addSublayer(previewLayer!)
        rootLayer = previewLayer?.superlayer
    }
    
    private func createRoundedRectLayer(with bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4).cgColor
        shapeLayer.cornerRadius = 7.0
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        CATransaction.commit()
        return shapeLayer
    }
    
    private func createTextSubLayer(in bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = String(format: "%@ %.2f", identifier, confidence)
        textLayer.bounds = bounds
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 1
        textLayer.shadowOffset = CGSize(width: -1, height: -1)
        textLayer.shadowRadius = 3
        textLayer.foregroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        textLayer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        textLayer.contentsScale = 2.0 // retina display support
        textLayer.font = CTFontCreateWithName("Arial" as CFString, 12, nil)
        textLayer.fontSize = 12
        return textLayer
    }
    
    private func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // Remove all the old recognized objects
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            let shapeLayer = createRoundedRectLayer(with: objectBounds)
            let textLayer = createTextSubLayer(in: objectBounds, identifier: topLabelObservation.identifier, confidence: topLabelObservation.confidence)
            print("text: \(topLabelObservation.confidence)")
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
        }
        rootLayer?.addSublayer(detectionOverlay)
        CATransaction.commit()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            DispatchQueue.main.async {
                if let results = request.results {
                    self?.drawVisionRequestResults(results)
                }
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}
