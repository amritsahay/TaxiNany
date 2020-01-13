//
//  NotificationVC.swift
//  TaxiNanny
//
//  Created by ip-d on 25/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //Mark - Button method
    
    @IBAction func menu(_ sender: Any) {
        AppDelegate.shared.openDrawer()
    }

}
