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

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configuration.worldAlignment = ARWorldTrackingConfiguration.WorldAlignment.gravityAndHeading
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func deleteNode(_ sender: Any) {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    @IBAction func saveRoute(_ sender: Any) {
        let childNodes = self.sceneView.scene.rootNode.childNodes
        
        let newRoute = Route(context: context)
        newRoute.name = "Route1"
        
        var index = 0
        for node in childNodes {
            let newNode = Node(context: context)
            newNode.id = Int32(index)
            newNode.x = node.position.x
            newNode.y = node.position.y
            newNode.z = node.position.z
            newNode.route = newRoute
            index = index + 1
        }
        
        //Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @IBAction func loadRoute(_ sender: Any) {
        do {
            // Create Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
            let routes = try context.fetch(fetchRequest) as! [Route]
            guard let route = routes.first else { return }
            guard let childNodes = route.nodes else { return }
            
            for nodeInSet in childNodes {
                let node = nodeInSet as! Node
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
    
    @IBAction func deleteRoute(_ sender: Any) {
        do {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            _ = try context.execute(request)
            
            let nodeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Node")
            let nodeRequest = NSBatchDeleteRequest(fetchRequest: nodeFetch)
            _ = try context.execute(nodeRequest)
        } catch {
            print("Deleting Failed")
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
