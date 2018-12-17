//
//  GameViewController.swift
//  MagicaVoxelImporter
//
//  Created by Will Powers on 12/29/16.
//  Copyright © 2016 Gyrocade, LLC. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = Bundle.main.path(forResource: "chr_rain", ofType: "vox") else {
            return
        }
        
        let scene = SCNScene()
        let modelNode = SCNNode()
        
        let model:MV_Model = MV_Model()
        let success = model.LoadModel(path: path)
        if success {
            
            let unitScale:CGFloat = 0.4
            
            if let voxels = model.voxels {
                for v in voxels {
            
                    let boxGeometry = SCNBox(width: unitScale, height: unitScale, length: unitScale, chamferRadius: 0)
                    let boxNode = SCNNode(geometry: boxGeometry)

                    if model.isCustomPalette {
                        let colorRGBA = model.palette[Int(v.colorIndex)]
                        boxGeometry.firstMaterial?.diffuse.contents = UIColor(red: CUnsignedInt(colorRGBA.r), green: CUnsignedInt(colorRGBA.g), blue: CUnsignedInt(colorRGBA.b), a: 255)
                    }
                    else
                    {
                        // adjust color index to be zero-indexed for the default palette
                        let colorHex = MV_Model.mv_default_palette[Int(v.colorIndex-1)]
                        boxGeometry.firstMaterial?.diffuse.contents = UIColor(colorHex: colorHex)
                    }
                    
                    let mx = -CGFloat(v.x) + CGFloat(model.sizex)/2.0
                    let my = CGFloat(v.z) - CGFloat(model.sizez)/2.0
                    let mz = CGFloat(v.y) - CGFloat(model.sizey)/2.0
                    
                    boxNode.position = SCNVector3(mx*unitScale, my*unitScale, mz*unitScale)
                    modelNode.addChildNode(boxNode)
                }
            }
        }
        
        modelNode.eulerAngles = SCNVector3(0, Float.pi, 0)
        scene.rootNode.addChildNode(modelNode)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        scnView.antialiasingMode = .multisampling4X
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
