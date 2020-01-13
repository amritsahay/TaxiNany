//
//  VehicleInsuranceViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 20/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class VehicleInsuranceViewController: UIViewController {

    @IBOutlet weak var lblissuon: UILabel!
    @IBOutlet weak var lblpolicy: UILabel!
    @IBOutlet weak var docimage: UIImageView!
    @IBOutlet weak var lblexpirydate: UILabel!
    @IBOutlet weak var lblcompanyname: UILabel!
    var list = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblissuon.text = list["issue_date"].stringValue
        lblpolicy.text = list["policy_no"].stringValue
        lblexpirydate.text = list["expiry_date"].stringValue
        lblcompanyname.text = list["company_name"].stringValue
        let u = Constant.ImagesUrl + list["image"].stringValue
        let url = URL(string: u)
        docimage.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
