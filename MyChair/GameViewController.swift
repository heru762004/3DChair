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
    // chair material
    var chair:SCNMaterial = SCNMaterial()
    // view
    var scnView:SCNView = SCNView()
    // chair node
    var chairShape:SCNNode = SCNNode()
    // fire particle system
    var particleSystem:SCNParticleSystem = SCNParticleSystem()
    // rain particle system
    var rainParticleSystem:SCNParticleSystem = SCNParticleSystem()
    // fire birth rate
    var fireBirthRate:CGFloat = 0.0
    // rain birth rate
    var rainBirthRate:CGFloat = 0.0
    
    var isAnimationStop:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let masterScene = SCNScene()
        // retrieve the SCNView
        scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = masterScene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // enable default lighting
        //scnView.autoenablesDefaultLighting = true
        
        // configure the view
        scnView.backgroundColor = UIColor.darkGrayColor()
        
        // load the chair dae resource to scene
        if let scene = SCNScene(named: "art.scnassets/Chair.dae") {
            if let shape = scene.rootNode.childNodeWithName("Chair.015", recursively: true) {
                chairShape = shape
                print(shape)
                chair = (shape.geometry?.firstMaterial)!
                chair.diffuse.contents = UIColor.blackColor()
                
                //chair?.diffuse.contents = UIColor.blackColor()//UIImage(named: "wood")//UIImage(named: "wood")
                scnView.scene?.rootNode.addChildNode(shape)
            }
        }
        
        
        // Create a reflective floor and configure it
        let floor = SCNFloor()
        floor.reflectionFalloffEnd = 100.0 // Set a falloff end value for the reflection
        floor.firstMaterial!.diffuse.contents = UIImage(named: "bg_wood")// Set a diffuse texture, here a pavement image
        
        // Create a node to attach the floor to, and add it to the scene
        let floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.name = "floor"
        scnView.scene?.rootNode.addChildNode(floorNode)
        
                
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
            
            if material == chair && isAnimationStop == true {
                isAnimationStop = false
                addFire()
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
    }
    
    // add fire to the chair
    func addFire() {
        particleSystem = SCNParticleSystem(named: "Fire", inDirectory: nil)!
        particleSystem.emitterShape = chairShape.geometry
        particleSystem.emissionDuration = 5.0
        fireBirthRate = particleSystem.birthRate
        chairShape.addParticleSystem(particleSystem)
        self.performSelector(Selector("showRain"), withObject: nil, afterDelay: 10.0)
    }
    
    // kill the fire
    func killFire() {
        particleSystem.birthRate = 0.0
        chairShape.removeParticleSystem(particleSystem)
        self.performSelector(Selector("killRain"), withObject: nil, afterDelay: 15.0)
    }
    
    // add water shower
    func showRain() {
        self.performSelector(Selector("killFire"), withObject: nil, afterDelay: 5.0)
        rainParticleSystem = SCNParticleSystem(named: "Rain", inDirectory: nil)!
        rainParticleSystem.warmupDuration = 1.0
        rainBirthRate = rainParticleSystem.birthRate
        chairShape.addParticleSystem(rainParticleSystem)
    }
    
    // stop the water shower
    func killRain() {
        rainParticleSystem.birthRate = 0.0
        chairShape.removeParticleSystem(rainParticleSystem)
        isAnimationStop = true
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
