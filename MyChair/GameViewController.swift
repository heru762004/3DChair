//
//  GameViewController.swift
//  MyChair
//
//  Created by Cassis Dev on 5/3/16.
//  Copyright (c) 2016 heru. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene(named: "art.scnassets/Chair.dae")!
                
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.darkGrayColor()
        
        let shape = scene.rootNode.childNodeWithName("Chair.015", recursively: true)
        print(shape)
        let chair = shape?.geometry?.firstMaterial
        chair?.diffuse.contents = UIColor(patternImage: UIImage(named: "wood")!)//UIImage(named: "wood")
        
        let spot = SCNLight()
        spot.type = SCNLightTypeSpot
        spot.castsShadow = true
        
        let spotNode = SCNNode()
        spotNode.light = spot
        spotNode.position = SCNVector3(x: 10, y: 150, z: 0)
        spotNode.castsShadow = true
        scene.rootNode.addChildNode(spotNode)
        
        
//        let wall = SCNNode(geometry: SCNBox(width: 400, height: 200, length: 4, chamferRadius: 0))
//        wall.geometry?.firstMaterial!.emission.contents = UIColor.lightGrayColor()
//        wall.geometry?.firstMaterial!.doubleSided = false
//        wall.castsShadow = true
//        wall.position = SCNVector3Make(10, 150, -85)
//        wall.physicsBody = SCNPhysicsBody.staticBody()
//        scene.rootNode.addChildNode(wall)

        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
