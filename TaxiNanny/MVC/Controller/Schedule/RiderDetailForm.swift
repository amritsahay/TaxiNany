//
//  RiderDetailForm.swift
//  TaxiNanny
//
//  Created by ip-d on 07/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class RiderDetailForm: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var location: UITextField!
    var riderid : Int!
    var placeDetail:[String:JSON]!
    var lAddress:String = ""
    var lLatitude:Double = 0
    var lLongitude:Double = 0
    var riderlist:[JSON] = []
    var setforall:Bool = false
    var indexdrop:Int = 0
    var callby:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let name  = placeDetail?["name"]?.stringValue
        let formatted_address = placeDetail?["formatted_address"]?.stringValue
        lAddress = name! + "," + formatted_address!
        let location1 = placeDetail["geometry"]?["location"].dictionary
        lLatitude = (location1?["lat"]!.doubleValue)!
        lLongitude = (location1?["lng"]!.doubleValue)!
        location.text = lAddress
        
        
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    // Marks - Button Method
    
    @IBAction func back(_ sender: Any) {
        // self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        if (name.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter name")
        }
        else{
            
            AddRiderFavouriteLocationApi()
            //  let selectRider = self.storyboard?.instantiateViewController(withIdentifier:"SelectedRiderVC") as! SelectedRiderVC
            //  self.navigationController?.pushViewController(selectRider, animated:true)
        }
    }
    
}

// webseevice
extension RiderDetailForm
{
    func AddRiderFavouriteLocationApi() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        //let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            headerValue = finalToken
        }
        
        let parameter:Parameters = ["rider_id":String( riderid!),"location_name":lAddress,"lattitude":lLatitude,"longitude":lLongitude,"nick_name":name.text!,"description":note.text!]
        
        let headers:HTTPHeaders? = ["Authorization":headerValue]
        
        let url = Constant.Baseurl + "addFavouriteLocations"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                Utility.shared.stopProgress()
                print(response.result)
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "true"
                    {
                        let data = dictionary?["data"]
                        let id = data!["id"].stringValue
                        self.setdata(id: id)
                        let selectRider = self.storyboard?.instantiateViewController(withIdentifier:"SelectedRiderVC") as! SelectedRiderVC
                        //self.navigationController?.popToViewController(selectRider, animated: true)
                        selectRider.alertpickup = ""
                        selectRider.riderlist = self.riderlist
                        self.navigationController?.pushViewController(selectRider, animated:true)
                    }
                    else
                    {
                        //
                    }
                }
                
            case .failure(let error):
                Utility.shared.stopProgress()
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
        }
    }
    
    func setdata(id:String){
        if callby == "drop"{
            if setforall{
                CommmanFunction.updateforalldrop(index: riderlist.count, value: lAddress, lat: String(lLatitude),long: String(lLongitude), drop_id: id)
            }else{
                CommmanFunction.updatedrop(index: self.indexdrop, value: lAddress, lat: String(lLatitude),long: String(lLongitude),drop_id: id)
            }
        }else if callby == "pick"{
            if setforall{
                CommmanFunction.updateforallpickup(index: riderlist.count, value: lAddress, lat: String(lLatitude), long: String(lLongitude),pick_id: id)
            }else{
                CommmanFunction.updatepickup(index: self.indexdrop, value: lAddress, lat: String(lLatitude), long: String(lLongitude),pick_id: id)
            }
        }
       
    }
    
}
