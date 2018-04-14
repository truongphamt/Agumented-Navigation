//
//  ARNavigationVC.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 4/14/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit
import ARKit
import CoreData

class ARNavigationVC: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var destination: Destination?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configuration.worldAlignment = ARWorldTrackingConfiguration.WorldAlignment.gravityAndHeading
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }

    override func viewDidAppear(_ animated: Bool) {
        do {
            //Thread.sleep(forTimeInterval: 3.0)
            // Create Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Node")
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Node.route), destination!)
            
            let childNodes = try context.fetch(fetchRequest) as! [Node]
            
            for node in childNodes {
                //Thread.sleep(forTimeInterval: 0.5)
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
