//
//  RiderForm2.swift
//  TaxiNanny
//
//  Created by ip-d on 17/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RiderForm2: UIViewController {
    
    @IBOutlet weak var isFontSeat: UISwitch!
    @IBOutlet weak var isBooster: UISwitch!
    
    var rider = RiderModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //updateUI()
    }
    
    // Mark:- Button methods
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
          self.addRiderApi()
    }
    
    @IBAction func boosterSeatChanged(_ sender: Any) {
        if isBooster.isOn == true
        {
            rider.needBooster = "1"
        }
        else
        {
            rider.needBooster = "0"
        }
    }
    
    @IBAction func frontSeatChanged(_ sender: Any) {
        if isFontSeat.isOn == true
        {
            rider.sitFrontSeat = "1"
        }
        else
        {
            rider.sitFrontSeat = "0"
        }
    }
    
    // Mark :- Other function
    
    func updateUI()
    {
        if let birthday = rider.dob.date(inFormat:"yyyy-MM-dd")
        {
            let age = birthday.age(birthday:birthday)
            if age < 6
            {
                isFontSeat.isEnabled = false
                isFontSeat.isOn = false
                isBooster.isOn = true
                isBooster.isEnabled = true
                rider.sitFrontSeat = "0"
                rider.needBooster = "1"
            }
            else
            {
                isFontSeat.isEnabled = true
                isFontSeat.isOn = false
                isBooster.isEnabled = false
                isBooster.isOn = true
                rider.sitFrontSeat = "0"
                rider.needBooster = "1"
            }
        }
    }
    
    func dialogAddAnother()
    {
        let alertViewController = UIAlertController(title:"Taxi Nanny", message:"Would you like to add another rider?", preferredStyle:.alert)
     
        let yesAction  = UIAlertAction(title:"Yes", style: .default) { (sender) in
            //TODO: Hit Add Child API and pop from stack
            self.popRiderForm1()
            alertViewController.dismiss(animated:true, completion:nil)
        }
        
        alertViewController.addAction(yesAction)
        
        let noAction  = UIAlertAction(title:"No", style: .default) { (sender) in
            //TODO: Hit Add Child API and pop from stack
             self.popParentHome()
            alertViewController.dismiss(animated:true, completion:nil)
        }
        
        alertViewController.addAction(noAction)
        self.present(alertViewController, animated:true, completion:nil)
    }
    
}

extension RiderForm2 // Navigation Method ParentHomeVC
{
    func popParentHome(){
        let viewControllers = self.navigationController?.viewControllers
        for viewController in viewControllers!
        {
            if viewController.isKind(of:AddRidersVC.self)
            {
                self.navigationController?.popToViewController(viewController, animated:true)
                break
            }
        }
    }
    
    func popRiderForm1()
    {
        let viewControllers = self.navigationController?.viewControllers
        for viewController in viewControllers!
        {
            if viewController.isKind(of:RiderForm1.self)
            {
                let rider_form = viewController as! RiderForm1
                rider_form.clearUI()
                self.navigationController?.popToViewController(viewController, animated:true)
                break
            }
        }
    }
}

// webseevice
extension RiderForm2
{
    func addRiderApi() {
        updateUI()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
           finalToken = "Bearer "+token1!
        }
        // conver int 12-Jun-2019
      
        
        let parameter:Parameters = ["first_name":rider.firstName!,"last_name":rider.lastName!,"parent_id":parentid,"birthday":rider.dob!,"gender":Int(rider.gender)!,"need_booster":Int(rider.needBooster)!,"sit_front_seat":Int(rider.sitFrontSeat)!]
        
        let headers:HTTPHeaders? = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "addRider"
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
                        self.dialogAddAnother()
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
