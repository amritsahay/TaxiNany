//
//  LoginVC.swift
//  TaxiNanny
//
//  Created by ip-d on 17/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {
    @IBOutlet weak var email_address: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var eye: UIButton!
    @IBOutlet weak var parentradio: UIImageView!
    @IBOutlet weak var driverradio: UIImageView!
    var isParent:Bool = true
    var iconClick = true
    var user_type: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        eye.tintColor = UIColor.lightGray
        password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //Mark - Button method
    @IBAction func login(_ sender: Any) {
        if (email_address.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter email address.")
            return
        }
        else if !(email_address.text?.isEmail)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter valid email address.")
            return
        }
        else if(password.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter password.")
            return
        }else if(user_type == ""){
            Utility.shared.showSnackBarMessage(message:"Please Select User Type")
            return
        }
            //        else if !(password.text?.isValidPassword)!
            //        {
            //            Utility.shared.showSnackBarMessage(message:"Please enter valid password.")
            //            return
            //        }
        else{
            loginApiCall()
            // showScreen()
        }
    }
    
    @IBAction func drivebtn(_ sender: Any) {
        user_type = "driver"
        parentradio.image = #imageLiteral(resourceName: "uncheckedradio")
        driverradio.image = #imageLiteral(resourceName: "checkedradio")
    }
    @IBAction func parentbtn(_ sender: Any) {
        user_type = "parent"
        parentradio.image = #imageLiteral(resourceName: "checkedradio")
        driverradio.image = #imageLiteral(resourceName: "uncheckedradio")
    }
    @IBAction func facebook(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func twitter(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func google_plus(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"ForgetPassword")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func register(_ sender: Any) {
        let register = self.storyboard?.instantiateViewController(withIdentifier:"RegisterType")
        self.navigationController?.pushViewController(register!, animated:true)
    }
    
    @IBAction func iconAction(sender: AnyObject) {
        if(iconClick == true) {
            password.isSecureTextEntry = false
            eye.tintColor = Constant().headerColor()
        } else {
            password.isSecureTextEntry = true
            eye.tintColor = UIColor.lightGray
        }
        
        iconClick = !iconClick
    }
    
    // Mark - Other UI Methods
    func showScreen()
    {
        //WelcomeVC
        if isParent == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"ParentHomeVC") as! ParentHomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            //DriverHomeVC
            let vc  = self.storyboard?.instantiateViewController(withIdentifier:"TabbarVC")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

// webseevice
extension LoginVC
{
    func loginApiCall() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let fcmtoken = UserDefaults.standard.value(forKey:"fcmtoken") as! String
        
        let parameter:Parameters = ["email":email_address.text!,"password":password.text!,"user_type":user_type]
        let headers:HTTPHeaders? = nil
        
        let url =  Constant.Baseurl + "login"
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
                        let responseJSON = JSON(response.result.value!)
                        
                        let data = dictionary?["data"]?.dictionary
                        let userData = data?["user_details"]?.dictionary
                        let jsondata = JSON(userData)
                        UserData.setUserdata(data: jsondata)
                        let number:Int = userData!.count
                        
                        if number == 2  {
                            self.selectlogin(dictionary: dictionary)
                            
                        }
                        else{
                            
                            let user =  responseJSON["data"]["user_details"][0].stringValue
                            
                            let userDetail = userData?["user_details_parent"]?.dictionary
                            let type = userDetail?["user_type"]?.string
                            //user_details_parent
                            //let type = userData?["user_type"]?.string
                            UserDefaults.standard.set(data?["token"]?.string, forKey:"token")
                            UserDefaults.standard.set(userDetail?["id"]?.intValue, forKey:"userid")
                            UserDefaults.standard.set(type, forKey:"user_type")
                            if type == "parent"{
                                self.isParent = true
                                self.showScreen()
                            }
                            else{
                                self.isParent = false
                                let userDetail = userData?["user_details_driver"]?.dictionary
                                UserDefaults.standard.set(userDetail?["id"]?.intValue, forKey:"userid")
                                self.showScreen()
                            }
                            
                        }
                     ////////////////
                       
                    }
                    else
                    {
                        // let error_message = dictionary?["error_message"]?.string
                        // self.delegate?.didAutoCompleteFailed(error:error_message)
                    }
                }
                
            case .failure(let error):
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                Utility.shared.showSnackBarMessage(message:"Incorrect Email Id and  password")
                print(error)
            }
        }
    }
    
    func selectlogin(dictionary:[String : SwiftyJSON.JSON]?) {
        
        let alert = UIAlertController(title: "Alert", message: "Would you like to login as:", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Driver", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("driver_view")
                //Yes
                
                let data = dictionary?["data"]?.dictionary
                let userData = data?["user_details"]?.dictionary
                
                let userDetail = userData?["user_details_driver"]?.dictionary
                let type = userDetail?["user_type"]?.string
                //user_details_parent
                //let type = userData?["user_type"]?.string
                UserDefaults.standard.set(data?["token"]?.string, forKey:"token")
                UserDefaults.standard.set(userDetail?["id"]?.intValue, forKey:"userid")
                
                if type == "parent"{
                    self.isParent = true
                    self.showScreen()
                }
                else{
                    self.isParent = false
                    self.showScreen()
                }
                
            case .cancel:
                print("parent_view")
                
                //no
                
            case .destructive:
                print("destructive")
                
            }}))
        
        let cancel = UIAlertAction(title: "Parent", style: .default, handler: { action in
             Utility.shared.showSnackBarMessage(message:"Only for Driver")
        })
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension LoginVC:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return  validate(string: newString)
    }
    
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
}
