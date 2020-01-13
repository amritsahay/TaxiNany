//
//  AddVehicleDetails.swift
//  TaxiNanny
//
//  Created by ip-d on 30/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddVehicleDetails: UIViewController {
    
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var model: UITextField!
    @IBOutlet weak var make: UITextField!
    
    var object:JSON = JSON()
    
    let yearPicker = TLMonthYearPickerView(frame: CGRect(x: 0, y: 0, width:0, height: 160))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
    }
    
    // Mark - Button methods
    
    @IBAction func next(_ sender: Any) {
        if validation()
        {
//            let uploadDocument = self.storyboard?.instantiateViewController(withIdentifier:"UploadDocumentsVC") as! UploadDocumentsVC
//            self.navigationController?.pushViewController(uploadDocument, animated:true)
            addvehicleDetailsApiCall()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    // Mark - Other Methods
    
    func setUI()
    {
        initYearControl()
    }
    
    func initYearControl()
    {
        yearPicker.calendar = Calendar(identifier: .gregorian)
        yearPicker.monthYearPickerMode = .year
        yearPicker.maximumDate = Date()
        yearPicker.delegate = self
        year.inputView = yearPicker
    }
    
    func validation() -> Bool
    {
        if (make.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please fill vehicle make name.")
            return false
        }
        else  if (model.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please fill vehicle model name.")
            return false
        }
        else  if (year.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please fill vehicle manufacture year.")
            return false
        }
        return true
    }
}

extension AddVehicleDetails:TLMonthYearPickerDelegate
{
    func monthYearPickerView(picker: TLMonthYearPickerView, didSelectDate date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from:date)
    }
}

// webseevice
extension AddVehicleDetails
{
    func addvehicleDetailsApiCall() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let userid =  UserDefaults.standard.value(forKey:"userid") as? Int
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            headerValue = finalToken
        }
        
        let parameter:Parameters = ["driver_id":userid!,"Vehicle_type_id":object["id"],"make":make.text!,"year":year.text!, "model":model.text!]
        
        let headers:HTTPHeaders? = ["Authorization":headerValue]
        
        let url = "http://178.128.116.149/taxinanny1/public/api/addvehicledetaildriver"
        Utility.shared.showSnackBarMessage(message:"Please wait.")
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
                        let uploadDocument = self.storyboard?.instantiateViewController(withIdentifier:"UploadDocumentsVC") as! UploadDocumentsVC
                        self.navigationController?.pushViewController(uploadDocument, animated:true)
                    }
                    else
                    {
                        Utility.shared.showSnackBarMessage(message:(dictionary?["message"]?.string)!)
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
