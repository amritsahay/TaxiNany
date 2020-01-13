//
//  ReviewYourTripVC.swift
//  TaxiNanny
//
//  Created by ip-d on 21/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Cosmos

class ReviewYourTripVC: UIViewController {

    @IBOutlet weak var totalfare: UILabel!
    @IBOutlet weak var totaldistance: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var Comment: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var needHelp: UIButton!
    @IBOutlet weak var rateNow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    // Marks - Button Method
    @IBAction func back(_ sender: Any) {
        // self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func needHelp(_ sender: Any) {
    
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParentHomeVC") as! ParentHomeVC
         self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func rateNow(_ sender: Any) {
    
    }
    
}
