//
//  RouteSelectionVC.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 4/9/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit
import CoreLocation

class HomeScreenVC: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "DeltaBeacons")
    var startingLocation: Start?
    var destinationLocation: Destination?
    @IBOutlet weak var fromTextView: UITextField!
    @IBOutlet weak var toTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let start = startingLocation {
            fromTextView.text = start.name
        }
        if let dest = destinationLocation {
            toTextView.text = dest.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons.count)
    }
    
    @IBAction func fromTouchDown(_ sender: Any) {
        performSegue(withIdentifier: "toStartSearch", sender: self)
    }
    @IBAction func toTouchDown(_ sender: Any) {
        performSegue(withIdentifier: "toDestinationSearch", sender: self)
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
