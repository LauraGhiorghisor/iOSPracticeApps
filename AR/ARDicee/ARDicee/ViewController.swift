//
//  ViewController.swift
//  ARDicee
//
//  Created by Laura Ghiorghisor on 21/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    
    var diceArray = [SCNNode]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // locating the horizontal plane, might take a while, so this helps debug it.
        // like smog face point woaha
        
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
        
        //        // Set the scene to the view
        //        sceneView.scene = diceScene
        
        
        
        
        //        }
        
        //        1. RED CUBE
        //scn = scene
        //        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIColor.red
        //        cube.materials = [material]
        //
        //
        //        let node = SCNNode()
        //        node.position = SCNVector3(0, 0.1, -0.5) // x y z axes
        //        node.geometry = cube
        //        sceneView.scene.rootNode.addChildNode(node)
        //        sceneView.autoenablesDefaultLighting = true
        
        
        
//                2. MOO N
                let moon = SCNSphere(radius: 0.2)
                let material = SCNMaterial()
                material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
                moon.materials = [material]
        
        
                let node = SCNNode()
                node.position = SCNVector3(0, 0.1, -0.5) // x y z axes
                node.geometry = moon
                sceneView.scene.rootNode.addChildNode(node)
                sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // this lines checks support
        if ARWorldTrackingConfiguration.isSupported  {
            let configuration = ARWorldTrackingConfiguration()
            // this is the more advanced, 9Chip requirement. )worldtracking)
            
            // PLANE DETECTION
            // currently no vertical? but horizontal: placing the dice
            
            configuration.planeDetection = .horizontal
            sceneView.session.run(configuration)
            
            
            
        } else {
            print("AR WorldTrack not supported")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    //MARK: - Detect touches
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let touchLocation = touch.location(in: sceneView)
//
//            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
//            //arhiottestresult
//            //            if !results.isEmpty {
//            //                //we did touch the plane
//            //                print("Did touch")
//            //            } else {
//            //                print("touched somewhere else")
//            //            }
//
//            if let hitResult = results.first {
//                //                print(hitResult)
//                // has localTransform (2d) and rotation and worldtransform
//                addDice(atLocation: hitResult)
//            }
//        }
//        //check for multi touch enabled too
//
//    }
//
//
//    func addDice(atLocation location: ARHitTestResult) {
//
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(
//                x: location.worldTransform.columns.3.x,
//                y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
//                z: location.worldTransform.columns.3.z)
//            diceArray.append(diceNode)
//            // creates an array as to roll all dice
//            sceneView.scene.rootNode.addChildNode(diceNode)
//            roll(dice: diceNode)
//        }
//    }
//
//    func rollAll () {
//        if !diceArray.isEmpty {
//            for dice in diceArray {
//                roll(dice: dice)
//            }
//        }
//    }
//
//
//    func roll(dice: SCNNode) {
//        //MARK: - Rotation animation
//        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2) // this is 90 mdegrees times 5?
//        let randomZ =  Float(arc4random_uniform(4) + 1) * (Float.pi/2)
//        // The function arc4random_uniform(_:) takes one parameter, the upper bound. It’ll return a random number between 0 and this upper bound, minus 1.
//        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX*5), y: 0, z: CGFloat(randomZ*5), duration: 0.5))
//    }
//
//
//    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
//
//        rollAll()
//    }
//
//
//    @IBAction func removeAll(_ sender: UIBarButtonItem) {
//        if !diceArray.isEmpty {
//            for dice in diceArray {
//                dice.removeFromParentNode()
//                //insane
//            }
//        }
//    }
//
//    //    allows shaking the app?
//    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        rollAll()
//    }
//
//
//    //MARK: - Detect horizontal surface ARSCNViewDelegate Methods
//    // tells the delegate a node has been added, a horizontal surface with an anchor (width, height)
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        // set up a new horizontal plane: anchor is real world coordinates
//        //        if anchor is ARPlaneAnchor {
//        ////            print("plane detected")
//        //
//        //        } else {
//        //            return
//        //        }
//
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {
//            return
//        }
//        let planeNode = createPlane(with: planeAnchor)
//        node.addChildNode(planeNode)
//
////        let planeAnchor = anchor as! ARPlaneAnchor //what?
//
//
//    }
//
//
//
//    //MARK: - Plane rendering methods
//    func createPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode{
//        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//              let planeNode = SCNNode()
//              planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
//
//              // the planes are normally generated as vertical
//              planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
//              let gridMaterial = SCNMaterial()
//              gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
//              plane.materials = [gridMaterial]
//              planeNode.geometry = plane
//
//              // or use  sceneView.scene.rootNode.
//        return planeNode
//    }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//    // MARK: - ARSCNViewDelegate
//
//    /*
//     // Override to create and configure nodes for anchors added to the view's session.
//     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//     let node = SCNNode()
//
//     return node
//     }
//     */
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
}
