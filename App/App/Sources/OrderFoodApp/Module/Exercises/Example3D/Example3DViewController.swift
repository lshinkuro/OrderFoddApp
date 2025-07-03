//
//  Example3DViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 29/10/24.
//

import UIKit
import SceneKit

class Example3DViewController: UIViewController {
    
    var sceneView: SCNView!
    var cameraNode: SCNNode!
    var isZoomedIn = false // Track zoom state


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
        loadFBXModel()
        setupCamera()
//        addPinchGesture()
        addDoubleTapGesture()
    }
    
    private func setupSceneView() {
        // Initialize SCNView
        sceneView = SCNView(frame: self.view.bounds)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sceneView.backgroundColor = .clear
        self.view.addSubview(sceneView)
    }
    
    private func loadFBXModel() {
        // Load the .fbx file as an SCNScene
        guard let scene = SCNScene(named: "sceneX.dae") else {
                  print("Failed to load .dae file.")
                  return
              }
        
        // Set up the SCNView to show the scene
        sceneView.scene = scene
        sceneView.allowsCameraControl = true // Enable user interaction with the model
        
        // Optional: Add lighting to the scene
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 40 // Default zoom level
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 30) // Set initial camera position
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
    }

    private func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.view != nil else { return }

        let zoomFactor: Float = gesture.scale < 1 ? 1.1 : 0.9 // Zoom in or out based on pinch
        cameraNode.position.z *= zoomFactor
        cameraNode.position.z = min(max(cameraNode.position.z, 5), 50) // Set zoom limits

        gesture.scale = 1.0
    }
    
    private func addDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(doubleTapGesture)
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let camera = cameraNode.camera else { return }
        
        if isZoomedIn {
              // Zoom out
              cameraNode.position.z = 10 // Move camera back
              camera.fieldOfView = 60 // Reset field of view
              print("Zoomed out")
          } else {
              // Zoom in
              cameraNode.position.z = 5 // Move camera closer
              camera.fieldOfView = 30 // Narrow field of view
              print("Zoomed in")
          }
          
          isZoomedIn.toggle() // Update zoom state
    }
}
