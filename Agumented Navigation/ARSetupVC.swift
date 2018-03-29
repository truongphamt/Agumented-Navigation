//
//  ViewController.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 2/18/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit
import ARKit
import CoreData

class ARSetupVC: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var destination: Destination?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configuration.worldAlignment = ARWorldTrackingConfiguration.WorldAlignment.gravityAndHeading
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }

    @IBAction func addNode(_ sender: Any) {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.05)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.position = location
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    @IBAction func removeLastNode(_ sender: Any) {
        let lastNode = self.sceneView.scene.rootNode.childNodes.last
        lastNode?.removeFromParentNode()
    }
    
    @IBAction func removeAllNodes(_ sender: Any) {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    @IBAction func saveRoute(_ sender: Any) {
        let childNodes = self.sceneView.scene.rootNode.childNodes
        
        var index = 0
        for node in childNodes {
            let newNode = Node(context: context)
            newNode.id = Int32(index)
            newNode.x = node.position.x
            newNode.y = node.position.y
            newNode.z = node.position.z
            newNode.route = destination
            index = index + 1
        }
        
        //Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @IBAction func loadRoute(_ sender: Any) {
        do {
            // Create Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Node")
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Node.route), destination!)
            let childNodes = try context.fetch(fetchRequest) as! [Node]
            
            for node in childNodes {
                let newNode = SCNNode()
                newNode.geometry = SCNSphere(radius: 0.05)
                newNode.geometry?.firstMaterial?.specular.contents = UIColor.white
                newNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                newNode.position = SCNVector3(node.x, node.y, node.z)
                
                self.sceneView.scene.rootNode.addChildNode(newNode)
            }
            
        } catch {
            print("Fetching Failed")
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
