//
//  LogoutPopupViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 04/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LogoutPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func logout(_ sender: Any) {
        logoutApi()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func pushViewController(viewController:UIViewController)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let navController = UINavigationController.init(rootViewController:viewController)
        navController.navigationBar.isHidden = true
        appDelegate.drawerController?.mainViewController = navController
        appDelegate.drawerController?.setDrawerState(.closed, animated: true)
    }
    
}

extension LogoutPopupViewController
{
    func logoutApi() {
        self.dismiss(animated: true, completion: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        
        let parameter:Parameters = [:]
        
        let headers:HTTPHeaders? = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "logout"
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
                        Constant.writeStringUserPreference(Constant.IsAutoLoginEnableKey, value: "\(0)")
                      
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"FirstViewController")
                        self.pushViewController(viewController: vc!)
                        
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
