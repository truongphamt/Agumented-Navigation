//
//  GetStartedVC.swift
//  Agumented Navigation
//
//  Created by Truong Pham on 4/11/18.
//  Copyright © 2018 UHCL. All rights reserved.
//

import UIKit

class GetStartedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedPressed(_ sender: Any) {
        performSegue(withIdentifier: "getStartedToHomeScreen", sender: self)
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
