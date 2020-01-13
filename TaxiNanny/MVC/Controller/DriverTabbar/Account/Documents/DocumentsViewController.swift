//
//  DocumentsViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 19/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class DocumentsViewController: UIViewController {
    var licence_details = JSON()
    var vehicle_documents = JSON()
    var VehicleInsurance = JSON()
    var VehiclePermit = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()

      getdata()
    }
    
    func getdata(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
       
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        
        
        
        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "driveralldetail"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                let resJson = JSON(response.result.value!)
                if resJson["status"] == "true"{
                    self.licence_details = resJson["licence_details"]
                    self.vehicle_documents = resJson["vehicle_documents"]
                    self.VehicleInsurance = resJson["VehicleInsurance"]
                    self.VehiclePermit = resJson["VehiclePermit"]
                }
            case .failure(let _):
                break
                
            }
            
        }
    }
    
    

    @IBAction func registration(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverWebViewViewController") as! DriverWebViewViewController
        vc.urlS = Constant.ImagesUrl + self.vehicle_documents["vehicle_registration_document"].stringValue
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func prmit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverWebViewViewController") as! DriverWebViewViewController
        vc.urlS = self.VehiclePermit["vehicle_permit_document"].stringValue
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func driverlicence(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverLicenceViewController") as! DriverLicenceViewController
        vc.list = licence_details
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func vehicleinsurance(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleInsuranceViewController") as! VehicleInsuranceViewController
        vc.list = VehicleInsurance
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
}
