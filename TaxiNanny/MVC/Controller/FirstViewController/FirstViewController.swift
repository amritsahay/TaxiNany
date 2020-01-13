//
//  FirstViewController.swift
//  TaxiNanny
//
//  Created by ip-d on 29/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(_ sender: Any) {
        let loginVC  = self.storyboard?.instantiateViewController(withIdentifier:"LoginVC") as! LoginVC
        self.navigationController?.pushViewController(loginVC, animated:true)
       // self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        let registerTypeVC = self.storyboard?.instantiateViewController(withIdentifier:"RegisterType") as! RegisterType
     self.navigationController?.pushViewController(registerTypeVC, animated: true)
      //  self.present(registerTypeVC, animated: true, completion: nil)
        
    }
}
