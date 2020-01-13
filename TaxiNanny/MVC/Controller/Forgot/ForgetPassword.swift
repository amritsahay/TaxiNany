//
//  ForgetPassword.swift
//  TaxiNanny
//
//  Created by ip-d on 17/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPassword: UIViewController {
    
    @IBOutlet weak var email_address: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPassword(_ sender: Any) {
    
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// webseevice
extension ForgetPassword
{
    func ForgetApiCall() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameter:Parameters = ["email":email_address.text!]
        
        let headers:HTTPHeaders? = nil
        
        let url = "http://178.128.116.149/taxinanny1/public/api/login"
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                
                print(response.result)
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "true"
                    {
                       
                        
                    }
                    else
                    {
                        //                        let error_message = dictionary?["error_message"]?.string
                        //                        self.delegate?.didAutoCompleteFailed(error:error_message)
                    }
                }
                
            case .failure(let error):
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
            
        }
        
    }
    
}
