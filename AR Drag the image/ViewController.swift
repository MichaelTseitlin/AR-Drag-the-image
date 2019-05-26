//
//  ViewController.swift
//  AR Drag the image
//
//  Created by Michael Tseitlin on 5/26/19.
//  Copyright © 2019 Michael Tseitlin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2
        configuration.planeDetection = [.horizontal, .vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}


// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        var anchors = [ARImageAnchor]()
        
        guard let currentImageAchor = anchor as? ARImageAnchor else { return }
        
        anchors.append(currentImageAchor)
        
        let name = currentImageAchor.referenceImage.name!
        
        switch name {
        case "200uah":
            nodeAdded(node, for: currentImageAchor, pasteImage: "1000usd")
            
            DispatchQueue.main.async {
                self.sceneView.session.remove(anchor: anchor)
            }
        case "200uahBack":
            nodeAdded(node, for: currentImageAchor, pasteImage: "1000usdBack")
            
            DispatchQueue.main.async {
                self.sceneView.session.remove(anchor: anchor)
            }
        default:
            print(#line, #function, "\(anchor)")
        }
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARImageAnchor, pasteImage name: String) {
        let refetenceImage = anchor.referenceImage
        let size = refetenceImage.physicalSize
        let plane = SCNPlane(width: 1.1 * size.width, height: 1.1 * size.height)
        
        plane.firstMaterial?.diffuse.contents = UIImage(named: name)
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
    }
}
