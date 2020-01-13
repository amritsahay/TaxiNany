//
//  DriverLicenceViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 19/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class DriverLicenceViewController: UIViewController {
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblexpiration: UILabel!
    @IBOutlet weak var lblcountry: UILabel!
    @IBOutlet weak var lblcity: UILabel!
    @IBOutlet weak var lbllicenceno: UILabel!
    @IBOutlet weak var lblstate: UILabel!
    @IBOutlet weak var lblzipcode: UILabel!
    @IBOutlet weak var docimage: UIImageView!
    @IBOutlet weak var lblbirthdate: UILabel!
    @IBOutlet weak var lbladdress1: UILabel!
    @IBOutlet weak var lbladdress2: UILabel!
    @IBOutlet weak var lblissuedon: UILabel!
    var list = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setdata()
    }
    
    func setdata(){
        lbllicenceno.text = list["licence_number"].stringValue
        lblname.text = list["fullname"].stringValue
        lblissuedon.text = list["issue_date"].stringValue
        lblbirthdate.text = list["dob"].stringValue
        lblexpiration.text = list["expiry_date"].stringValue
        lbladdress1.text = list["address1"].stringValue
        lbladdress2.text = list["address2"].stringValue
        lblzipcode.text = list["zip_code"].stringValue
        let u = Constant.ImagesUrl + list["image"].stringValue
        let url = URL(string: u)
        docimage.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
