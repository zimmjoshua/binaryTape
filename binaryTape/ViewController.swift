// new comment
//  ViewController.swift
//  binaryTape
//
//  Created by Joshua Zimmerman, Hopper Kremer, Jimmy Shah, Julian Van Court-Wels on 11/4/17.
//  Copyright © 2017 Joshua Zimmerman, Hopper Kremer, Jimmy Shah, Julian Van Court-Wels. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var textNodeA = SCNNode()
    var textNodeB = SCNNode()
    var textNodeC = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self 
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    // Function to take user touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // If more than three dot touch locations exist, remove dot locations
        if dotNodes.count >= 3 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
            
        }
    }
    
    // Creates the dot material color and size
    func addDot(at hitResult : ARHitTestResult) {
        let dotGeometry = SCNSphere(radius: 0.002)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        // When three touch locations exist, call function to calculate distances between dots
        if dotNodes.count >= 3 {
            calculate()
        }
    }
    
    // Calculates the distance of each dotNode from the previous dotNode
    func calculate (){
        let start = dotNodes[0]
        let middle = dotNodes[1]
        let end = dotNodes[2]
        
//        print(start.position)
//        print(middle.position)
//        print(end.position)
        
        // Calculates the distances in millimeters
        let a = (sqrt(
            pow(middle.position.x - start.position.x, 2) +
                pow(middle.position.y - start.position.y, 2) +
                pow(middle.position.z - start.position.z, 2)
        )) * 1000
        
        let b = (sqrt(
            pow(end.position.x - middle.position.x, 2) +
                pow(end.position.y - middle.position.y, 2) +
                pow(end.position.z - middle.position.z, 2)
        )) * 1000
        let c = sqrt((pow(a, 2) + pow(b, 2)))
        
        // Converts millimeter value to an absolute integer value
        // Converts the Aboslute Integer value of distance to a String, base 2 binary representation

        let intA = abs(Int(a))
        
        let binaryA = String(intA, radix: 2)
        
        let intB = abs(Int(b))
        
        let binaryB = String(intB, radix: 2)
        
        let intC = abs(Int(c))
        
        let binaryC = String(intC, radix: 2)
        
        // Calls function to Update the text in 3D space with both the decimal and binary measure
        updateTextA(text: ("a = \(a)mm\n" + binaryA), atPosition: start.position)
        updateTextB(text: ("b = \(b)mm\n" + binaryB), atPosition: middle.position)
        updateTextC(text: ("c = \(c)mm\n" + binaryC), atPosition: end.position)
        
       
        
        
        
    }
    
    // Updates the text in 3D space with both the decimal and binary measure
    func updateTextA(text: String, atPosition position: SCNVector3){
        
        textNodeA.removeFromParentNode()
        
        let textGeometryA = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometryA.firstMaterial?.diffuse.contents = UIColor.black
        
        textNodeA = SCNNode(geometry: textGeometryA)
        
        textNodeA.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNodeA.scale = SCNVector3(0.001, 0.001, 0.001)
        
        sceneView.scene.rootNode.addChildNode(textNodeA)
        
    }
    
       // Updates the text in 3D space with both the decimal and binary measure
    func updateTextB(text: String, atPosition position: SCNVector3){
        
        textNodeB.removeFromParentNode()
        
        let textGeometryB = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometryB.firstMaterial?.diffuse.contents = UIColor.black
        
        textNodeB = SCNNode(geometry: textGeometryB)
        
        textNodeB.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNodeB.scale = SCNVector3(0.001, 0.001, 0.001)
        
        sceneView.scene.rootNode.addChildNode(textNodeB)
        
    }
    
       // Updates the text in 3D space with both the decimal and binary measure
    func updateTextC(text: String, atPosition position: SCNVector3){
        
        textNodeC.removeFromParentNode()
        
        let textGeometryC = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometryC.firstMaterial?.diffuse.contents = UIColor.black
        
        textNodeC = SCNNode(geometry: textGeometryC)
        
        textNodeC.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNodeC.scale = SCNVector3(0.001, 0.001, 0.001)
        
        sceneView.scene.rootNode.addChildNode(textNodeC)
        
    }
    

}


