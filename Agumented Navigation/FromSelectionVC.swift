//
//  FromSelectionVC.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 4/14/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit
import CoreData

class FromSelectionVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    var startingLocations: [Start] = []
    var filteredLocations: [Start] = []
    
    override func viewDidLoad() {
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        // Configure the cell...
        let start = filteredLocations[indexPath.row]
        cell.textLabel?.text = start.name
        
        return cell
    }
    
    // perform seque to converterViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
                if let homeVC = navController.viewControllers[0] as? HomeScreenVC {
                    homeVC.startingLocation = filteredLocations[(self.tableView.indexPathForSelectedRow?.row)!]
                }
            }
        }
    }
    
    func getData() {
        do {
            // Create Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Start")
            
            // Add Sort Descriptor
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // Add Predicate
            //let predicate = NSPredicate(format: "item CONTAINS %@", "Chicken")
            //fetchRequest.predicate = predicate
            
            startingLocations = try context.fetch(fetchRequest) as! [Start]
            filteredLocations = startingLocations
        } catch {
            print("Fetching Failed")
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredLocations = startingLocations.filter { loc in
                return (loc.name?.lowercased().contains(searchText.lowercased()))!
            }
            
        } else {
            filteredLocations = startingLocations
        }
        tableView.reloadData()
    }
}
