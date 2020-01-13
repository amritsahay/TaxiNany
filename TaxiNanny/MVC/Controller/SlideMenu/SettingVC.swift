//
//  SettingVC.swift
//  TaxiNanny
//
//  Created by ip-d on 25/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SettingVC: UIViewController {

    @IBOutlet weak var switchtext: UISwitch!
    @IBOutlet weak var switchpush: UISwitch!
    var push:Int = 0
    var textmsg:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pushnotify(_ sender: UISwitch) {
        if sender.isOn{
            self.push = 1
        }else{
            self.push = 0
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        let parameter = ["status":push]
        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "change-push-settings"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                let resJson = JSON(response.result.value!)
                if resJson["is_enable_push_notifications"].intValue == 1{
                     Utility.shared.showSnackBarMessage(message:"Push Notifications are ON now.")
                }else{
                     Utility.shared.showSnackBarMessage(message:"Push Notifications are OFF now.")
                }
                
            case .failure(let _):
                break
                
            }
            
        }
    }
    
    @IBAction func txtmsgalert(_ sender: UISwitch) {
        if sender.isOn{
            self.textmsg = 1
        }else{
            self.textmsg = 0
        }
      
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        
        
        let parameter = ["status":push]
        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "change-text-settings"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                let resJson = JSON(response.result.value!)
                if resJson["is_enable_text_message_alert"].intValue == 1{
                    Utility.shared.showSnackBarMessage(message:"Text Message Alerts are ON Now.")
                }else{
                    Utility.shared.showSnackBarMessage(message:"Text Message Alerts are OFF Now.")
                }
            case .failure(let _):
                self.dismiss(animated: true, completion: nil)
                break
                
            }
            
        }
    }
    
    @IBAction func emergency(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewcontrol: EmergencyContactViewController = storyboard.instantiateViewController(withIdentifier: "EmergencyContactViewController") as! EmergencyContactViewController
        self.present(viewcontrol, animated: true, completion: nil)
    }
    
    @IBAction func chnagepassword(_ sender: Any) {
        let viewcontrol:ChangePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.present(viewcontrol, animated: true, completion: nil)
    }
  
    @IBAction func menu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
