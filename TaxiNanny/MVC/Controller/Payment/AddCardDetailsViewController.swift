//
//  AddCardDetailsViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 09/10/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SkyFloatingLabelTextField

class AddCardDetailsViewController: UIViewController {

    @IBOutlet weak var txtcardname: UITextField!
   
    @IBOutlet weak var txtexpirydate: UITextField!
    @IBOutlet weak var txtccvno: UITextField!
    
    @IBOutlet weak var txtcardno: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtcardno.leftViewMode = UITextField.ViewMode.always
        txtcardno.leftView = UIImageView(image: UIImage(named : "Credit-card"))
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let cardname = txtcardname.text
        if (cardname?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter card holder name")
            return
        }
        let cardno = txtcardno.text
        if (cardno?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter card number")
            return
        }
        let ccv = txtccvno.text
        if (ccv?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter card details")
            return
        }
        let expiry = txtexpirydate.text
        if (expiry?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter card details")
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Utility.shared.startProgress(message:"Please wait.")
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            headerValue = finalToken
        }
        
        let parameter = ["card_number":cardno,"expiry_date":expiry,"cvv":ccv]
        let headers = ["Authorization":headerValue]
        
        let url =  Constant.Baseurl + "card/add" 
        
        Alamofire.request(url, method: .get, parameters: parameter, encoding:JSONEncoding.default, headers: headers).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                print(response.result)
                let responseJSON = JSON(response.result.value!)
                
            case .failure(let error):
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
        }
    }
}
