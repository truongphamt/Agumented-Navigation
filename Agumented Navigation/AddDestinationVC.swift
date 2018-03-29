//
//  AddDestinationVC.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 3/27/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit
import CoreData

class AddDestinationVC: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var startingLocation: Start?
    //var destination: Destination?
    
    @IBOutlet weak var name: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        self.name.text = ""
    }
    
    @IBAction func addDestination(_ sender: Any) {
        
        let newDestination = Destination(context: context)
        
        newDestination.name = self.name.text
        newDestination.start = startingLocation
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
