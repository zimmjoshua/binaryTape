// new comment
//  ViewController.swift
//  binaryTape
//
//  Created by Joshua Zimmerman on 11/4/17.
//  Copyright © 2017 Joshua Zimmerman. All rights reserved.
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
    
    
 
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    
    func addDot(at hitResult : ARHitTestResult) {
        let dotGeometry = SCNSphere(radius: 0.002)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 3 {
            calculate()
        }
    }
    
    func calculate (){
        let start = dotNodes[0]
        let middle = dotNodes[1]
        let end = dotNodes[2]
        
        print(start.position)
        print(middle.position)
        print(end.position)
        
        // Calculates distance in centimeters
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
        
        // Converts centimeter value to an absolute integer value
        let intA = abs(Int(a))
        
        // Converts the Aboslute Integer value of distance to a String, base 2 binary representation
        let binaryA = String(intA, radix: 2)
        
        let intB = abs(Int(b))
        
        let binaryB = String(intB, radix: 2)
        
        let intC = abs(Int(c))
        
        let binaryC = String(intC, radix: 2)
        
        /*
 
         let intdistance1 = abs(Int(distance1))
         
         // Converts the Aboslute Integer value of distance to a String, base 2 binary representation
         let Distance1InBinary = String(intdistance1, radix: 2)
         
         let intdistance2 = abs(Int(distance2))
         
         let Distance2InBinary = String(intdistance2, radix: 2)
         
         let inthyp = abs(Int(hyp))
         
         let binaryHyp = String(inthyp, radix: 2)
 */
        
//        func vSubtract(left:SCNVector3, right:SCNVector3) -> SCNVector3 {
//
//            return left + (right  -1.0)
//        }
//
//        func vMultiply(vector:SCNVector3, multiplier:SCNFloat) -> SCNVector3 {
//
//            return SCNVector3(vector.x * multiplier, vector.y * multiplier, vector.z * multiplier)
//        }
        
      //  var newVector = vSubtract(middle.position, start.position)
        //var coeff SCNFloat = 0.5
       // vMultiply(newVector, 0.5)
        
        

        

        
        
        //SCNVector3 kjhkjh = new SCNVector3()
        
        //updateText(text: "\(myDistanceInBinary)", atPosition: end.position)
        
        /*updateTextA(text: "a = \(distance1)", atPosition: start.position)
        updateTextB(text: "b = \(distance2)", atPosition: middle.position)
        updateTextC(text: "c = \(hyp)\n ", atPosition: end.position)
 */
        updateTextA(text: ("a = \(a)mm\n" + binaryA), atPosition: start.position)
        
        updateTextB(text: ("b = \(b)mm\n" + binaryB), atPosition: middle.position)
        updateTextC(text: ("c = \(c)mm\n" + binaryC), atPosition: end.position)
        //        distance = √ ((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
       
        
        
        
    }
    
    func updateTextA(text: String, atPosition position: SCNVector3){
        
        textNodeA.removeFromParentNode()
        
        let textGeometryA = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometryA.firstMaterial?.diffuse.contents = UIColor.black
        
        textNodeA = SCNNode(geometry: textGeometryA)
        
        textNodeA.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNodeA.scale = SCNVector3(0.001, 0.001, 0.001)
        
        sceneView.scene.rootNode.addChildNode(textNodeA)
        
    }
    
    func updateTextB(text: String, atPosition position: SCNVector3){
        
        textNodeB.removeFromParentNode()
        
        let textGeometryB = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometryB.firstMaterial?.diffuse.contents = UIColor.black
        
        textNodeB = SCNNode(geometry: textGeometryB)
        
        textNodeB.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNodeB.scale = SCNVector3(0.001, 0.001, 0.001)
        
        sceneView.scene.rootNode.addChildNode(textNodeB)
        
    }
    
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


