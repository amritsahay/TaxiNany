//
//  BookingPopupViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 26/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit

class BookingPopupViewController: UIViewController {

    @IBOutlet weak var lblmsg: UILabel!
    var msg:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmsg.text = msg
    }
    
    func pushViewController(viewController:UIViewController)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let navController = UINavigationController.init(rootViewController:viewController)
        navController.navigationBar.isHidden = true
        appDelegate.drawerController?.mainViewController = navController
        appDelegate.drawerController?.setDrawerState(.closed, animated: true)
    }
    
    @IBAction func ok(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"ParentHomeVC") as! ParentHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
