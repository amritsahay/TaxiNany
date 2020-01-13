//
//  EditFavouriteLocationVC.swift
//  TaxiNanny
//
//  Created by Shashwat B on 22/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditFavouriteLocationVC: UIViewController {

    @IBOutlet weak var txtlocation: UITextField!
    @IBOutlet weak var txtnote: UITextView!
    @IBOutlet weak var txtnickname: UITextField!
    var var_loc:String = ""
    var var_note:String = ""
    var var_nike:String = ""
    var lat:String = ""
    var long:String = ""
    var id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtlocation.text = var_loc
        self.txtnote.text = var_note
        self.txtnickname.text = var_nike
    }

    @IBAction func save(_ sender: Any) {
        let loc = txtlocation.text
        if loc == ""{
            Utility.shared.showSnackBarMessage(message: "Plesae choose favourite location")
            return
        }
       
        let nick = txtnickname.text
        if nick == ""{
            Utility.shared.showSnackBarMessage(message: "Plesae Enter Nick Name")
            return
        }
       
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let user_id = String(parentid)
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        let parameter = ["location_name":loc,"lattitude":lat,"longitude":long,"id":id,"nick_name":nick,"rider_id":user_id]
        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "updatefavoratelocation"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                let resJson = JSON(response.result.value!)
                let msg = resJson["message"].stringValue
                if resJson["status"] == "true"{
                    Utility.shared.showSnackBarMessage(message: msg)
                }else{
                    Utility.shared.showSnackBarMessage(message: msg)
                }
            case .failure(let _):
                break
                
            }
            
        }
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
