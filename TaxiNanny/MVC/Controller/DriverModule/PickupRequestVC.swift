//
//  PickupRequestVC.swift
//  TaxiNanny
//
//  Created by ip-d on 19/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import Alamofire

class PickupRequestVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var esttime: UILabel!
    @IBOutlet weak var estfare: UILabel!
    @IBOutlet weak var estDistance: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"PickupRequestVC")
        vc!.modalPresentationStyle = .overCurrentContext
        vc!.modalTransitionStyle = .crossDissolve
        self.present(vc!, animated: true, completion: nil)
    }
    
    
     //Mark - Button method

    @IBAction func accept(_ sender: Any) {
       
      SocketLayer.shared.updateStatus(Status: 1)
      driverAcceptApiCall()
      // Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func reject(_ sender: Any) {
        
        SocketLayer.shared.updateStatus(Status: 2)
        rejectrequestApiCall()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    
    }
    
}

// webseevice
extension PickupRequestVC
{
    func driverAcceptApiCall() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let Driverid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        // conver int 12-Jun-2019
        
        let parameter:Parameters = ["booking_id":""]
        
        let headers:HTTPHeaders? = ["Authorization":finalToken]
        
        let url =  Constant.Baseurl + "acceptRequest"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                print(response.result)
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "true"
                    {
                        //
                    }
                    else
                    {
                        //
                    }
                }
                
            case .failure(let error):
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }

        }
    }
    
    //
    func rejectrequestApiCall() {
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let Driverid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        // conver int 12-Jun-2019
        
        let parameter:Parameters = ["booking_id":""]
        
        let headers:HTTPHeaders? = ["Authorization":finalToken]
        
        let url =  Constant.Baseurl + "rejectRequest"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                print(response.result)
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "true"
                    {
                        //
                    }
                    else
                    {
                        //
                    }
                }
                
            case .failure(let error):
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
            
        }
    }
    
}
