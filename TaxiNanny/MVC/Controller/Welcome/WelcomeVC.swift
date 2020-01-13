//
//  WelcomeVC.swift
//  TaxiNanny
//
//  Created by ip-d on 17/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addRider(_ sender: Any) {
   
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"RiderForm1")
            self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func skip(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
