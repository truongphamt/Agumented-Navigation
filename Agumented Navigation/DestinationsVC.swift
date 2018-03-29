//
//  DestinationsVC.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 3/27/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit
import CoreData

class DestinationsVC: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var destinations: [Destination] = []
    var startingLocation: Start?
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return destinations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        let destination = destinations[indexPath.row]
        cell.textLabel?.text = destination.name
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let destination = destinations[indexPath.row]
            context.delete(destination)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            getData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "destinationToARCamera", sender: self)
        }
    }
    
    func getData() {
        do {
            // Create Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Destination")
            
            // Add Sort Descriptor
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // Add Predicate
            let predicate = NSPredicate(format: "%K == %@", #keyPath(Destination.start), startingLocation!)
            fetchRequest.predicate = predicate
            
            destinations = try context.fetch(fetchRequest) as! [Destination]
        } catch {
            print("Fetching Failed")
        }
        tableView.reloadData()
    }

    @IBAction func addDestination(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddDestination", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let viewController = segue.destination as? AddDestinationVC {
            viewController.startingLocation = startingLocation
        }
        else if let viewController = segue.destination as? ARSetupVC {
            viewController.destination = destinations[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }

}
