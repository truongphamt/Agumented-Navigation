//
//  AddStartingLocationVC.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 3/26/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit
import CoreData

class AddStartingLocationVC: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var name: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        self.name.text = ""
    }
    
    @IBAction func addStart(_ sender: Any) {
        
        let newStart = Start(context: context)
        newStart.name = self.name.text
        //newStart.beaconID = self.beacon.text
        
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
