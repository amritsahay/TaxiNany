//
//  RegisterForm.swift
//  TaxiNanny
//
//  Created by ip-d on 17/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Navajo_Swift
import GooglePlaces


class RegisterForm: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtccv: UITextField!
    @IBOutlet weak var txtexpirydate: UITextField!
    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var txtcardhname: UITextField!
    @IBOutlet weak var txtcardnmbr: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm_password: UITextField!
    @IBOutlet weak var phone_number: UITextField!
    @IBOutlet weak var email_address: UITextField!
    @IBOutlet weak var eyes: UIButton!
   
    @IBOutlet weak var home_address: UITextField!
    @IBOutlet weak var eyes1: UIButton!
    @IBOutlet weak var strenthview: UIProgressView!
    @IBOutlet private weak var strengthLabel: UILabel!
    @IBOutlet private weak var validationLabel: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgViewSpecialChar: UIImageView!
    @IBOutlet weak var specialChar: UILabel!
    @IBOutlet weak var Char: UILabel!
    @IBOutlet weak var imgViewUpper: UIImageView!
    @IBOutlet weak var upper: UILabel!
    @IBOutlet weak var checkbtnview: UIButton!
    @IBOutlet weak var imgViewNumber: UIImageView!
    @IBOutlet weak var atLeast: UILabel!
     var searchTxt = ""
    private var validator = PasswordValidator.standard
    var uppercase = false
    var isParent:Bool = true
    var iconClick = true
    var iconClick1 = true
    var check:Bool  = false
    var home_lat:Double?
    var home_log:Double?
    var push:Int = 0
    var textmsg:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtccv.delegate = self
        txtcardnmbr.delegate = self
        txtexpirydate.delegate = self
        txtcardhname.delegate = self
        phone_number.delegate = self
        first_name.delegate = self
        last_name.delegate = self
        password.delegate = self
        home_address.delegate = self
        eyes.tintColor = UIColor.lightGray
        eyes1.tintColor = UIColor.lightGray
        validationLabel.isHidden = true
        home_address.addTarget(self, action: #selector(placeSearch), for: .editingDidBegin)
       // phone_number.textContentType = .telephoneNumber
    
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Marks - Button Method
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func register(_ sender: Any) {
        if validation()
        {
            if let txt = password.text {
                if ((txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil)){
                    Utility.shared.showSnackBarMessage(message:"UpperCase letter missing")
                }else{
                    registerApiCall()
                }
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        searchTxt = textField.text!
        //        let uuid = UUID()
        //        GoogleAPI.shared.autoComplete(keyword:searchTxt , session: uuid.uuidString)
        //        GoogleAPI.shared.delegate = self
        if textField == home_address{
            home_address.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }

    }
    

    
   
    @objc func placeSearch(textField: UITextField) {
        if textField == home_address{
            home_address.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }
       
    }
    
    @IBAction func facebook(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func twitter(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func checkbtn(_ sender: Any) {
        if check{
           self.checkbtnview.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
           self.check = false
        }else{
            self.checkbtnview.setImage(#imageLiteral(resourceName: "checkbox_checked"), for: .normal)
            self.check = true
        }
    }
    @IBAction func google_plus(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func iconAction(sender: AnyObject) {
        if(iconClick == true) {
            password.isSecureTextEntry = false
            eyes.tintColor = Constant().headerColor()
        } else {
            password.isSecureTextEntry = true
            eyes.tintColor = UIColor.lightGray
        }
        iconClick = !iconClick
    }
    @IBAction func pushnotify(_ sender: UISwitch) {
        if sender.isOn{
            self.push = 1
        }else{
            self.push = 0
        }
    }
    @IBAction func txtmsgalert(_ sender: UISwitch) {
        if sender.isOn{
            self.textmsg = 1
        }else{
            self.textmsg = 0
        }
    }
    @IBAction func iconAction(_ sender: Any) {
    
        if(iconClick1 == true) {
            confirm_password.isSecureTextEntry = false
            eyes1.tintColor = Constant().headerColor()
        } else {
            confirm_password.isSecureTextEntry = true
            eyes1.tintColor = UIColor.lightGray
        }
        iconClick1 = !iconClick1
        
    }
    
    // Mark - Other function
    
    func validation() -> Bool
    {
        if (first_name.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter first name")
            return false
        }
        else if (last_name.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter last name.")
            return false
        }
        else if (email_address.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter email address.")
            return false
        }
        else if !(email_address.text?.isEmail)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter valid email address.")
            return false
        }
        else if (phone_number.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter phone number.")
            return false
        }else if (home_address.text?.isBlank)!{
            Utility.shared.showSnackBarMessage(message:"Please enter home address")
            return false
        }
        else if(password.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter password.")
            return false
        }
            
        else if !(password.text?.isValidPassword)!
        {
//            Utility.shared.showSnackBarMessage(message:"Please enter valid password.Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:")
           
        }
            
        else if (!(password.text == confirm_password.text)){
            Utility.shared.showSnackBarMessage(message:"Password didn't match")
            return false
        }else if (txtcardhname.text?.isBlank)!{
            Utility.shared.showSnackBarMessage(message:"Please enter card holder name")
            return false
        }else if (txtcardnmbr.text?.isBlank)!{
            Utility.shared.showSnackBarMessage(message:"Please enter card number")
            return false
        }else if (txtexpirydate.text?.isBlank)!{
            Utility.shared.showSnackBarMessage(message:"Please enter card details")
            return false
        }else if (txtccv.text?.isBlank)!{
            Utility.shared.showSnackBarMessage(message:"Please enter card details")
            return false
        }else if !check{
            Utility.shared.showSnackBarMessage(message:"Please Accept Terms Conditions & Privacy Policy")
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //test case
        
        if textField == phone_number
        {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if textField == last_name{
            let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            return string.rangeOfCharacter(from: set) == nil
        }else if textField == first_name{
            let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            return string.rangeOfCharacter(from: set) == nil
        }else if textField == txtcardhname{
            let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
            return string.rangeOfCharacter(from: set) == nil
        }else if textField == txtcardnmbr{
            if txtcardnmbr.text?.count == 4 || txtcardnmbr.text?.count == 9 || txtcardnmbr.text?.count == 14{
                txtcardnmbr.text = txtcardnmbr.text! + " "
            }
            let set = NSCharacterSet(charactersIn: "1234567890").inverted
            return string.rangeOfCharacter(from: set) == nil
        }else if textField == txtexpirydate{
            if txtexpirydate.text?.count == 2{
                txtexpirydate.text = txtexpirydate.text! + "/"
            }
            let set = NSCharacterSet(charactersIn: "1234567890").inverted
            return string.rangeOfCharacter(from: set) == nil
        }else if textField == password {
            //test
            if let txt = password.text {
                if (!(txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil)){
                   // errorMsg += "one upper case letter"
                    //upper.textColor = Constant().headerColor()
                    //imgViewUpper.tintColor = Constant().headerColor()
                    uppercase = true
                    
                }
                if (!(txt.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil) &&  !(txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil)) {
                   // errorMsg += ", one lower case letter"
                    upper.textColor = Constant().headerColor()
                    imgViewUpper.tintColor = Constant().headerColor()
                }
                if (!(txt.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil)) {
                    //errorMsg += ", one number"
                    atLeast.textColor = Constant().headerColor()
                    imgViewNumber.tintColor = Constant().headerColor()
                    
                }
                let specialCharacters = "!@#$&%^.?*;"
                let charset = CharacterSet(charactersIn: specialCharacters)
                if (!(string.rangeOfCharacter(from: charset) == nil)) {
                    //errorMsg += ", one Special Charecter"
                    specialChar.textColor = Constant().headerColor()
                    imgViewSpecialChar.tintColor = Constant().headerColor()
                    
                }
                if txt.count >= 7 {
                   // errorMsg += ", and eight characters"
                    Char.textColor = Constant().headerColor()
                    imgView1.tintColor = Constant().headerColor()
                }
                if txt.count == 0 {
                    
                    upper.textColor = UIColor.lightGray
                    imgViewUpper.tintColor = UIColor.lightGray
                    atLeast.textColor = UIColor.lightGray
                    imgViewNumber.tintColor = UIColor.lightGray
                    Char.textColor = UIColor.lightGray
                    imgView1.tintColor = UIColor.lightGray
                    specialChar.textColor = UIColor.lightGray
                    imgViewSpecialChar.tintColor = UIColor.lightGray
                }
                
                if (password.text?.isBlank)!
                {
                    upper.textColor = UIColor.lightGray
                    imgViewUpper.tintColor = UIColor.lightGray
                    atLeast.textColor = UIColor.lightGray
                    imgViewNumber.tintColor = UIColor.lightGray
                    Char.textColor = UIColor.lightGray
                    imgView1.tintColor = UIColor.lightGray
                    specialChar.textColor = UIColor.lightGray
                    imgViewSpecialChar.tintColor = UIColor.lightGray
                }
                
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        print("Backspace was pressed")
                        
                        upper.textColor = UIColor.lightGray
                        imgViewUpper.tintColor = UIColor.lightGray
                        atLeast.textColor = UIColor.lightGray
                        imgViewNumber.tintColor = UIColor.lightGray
                        Char.textColor = UIColor.lightGray
                        imgView1.tintColor = UIColor.lightGray
                        specialChar.textColor = UIColor.lightGray
                        imgViewSpecialChar.tintColor = UIColor.lightGray
                        
                    }
                }
                
            }
            
            //
            return true
        }
            
            
        else
        {
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return  validate(string: newString)
        }
        
    }
    
    func validate(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    ////test
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
//        if (textField == password) {
//            validationLabel.isHidden = true
//            validatePassword()
//        }
//
//        else if (textField == confirm_password){
//           validationLabel.isHidden = true
//        }
    }

}

// webseevice
extension RegisterForm
{
    func registerApiCall() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var user_type:NSString = ""
        
        if isParent {
            user_type = "parent"
        }
            
        else{
            user_type = "driver"
        }
        
       let fcmtoken = UserDefaults.standard.value(forKey:"fcmtoken") as! String
   
        let parameter:Parameters = ["first_name":first_name.text!,"last_name":last_name.text!,"email":email_address.text!,"phone_no":phone_number.text!,"user_type":user_type,"password":confirm_password.text!,"card_holder_name":txtcardhname,"card_number":txtcardnmbr,"cvv":txtccv,"expiry_date":txtexpirydate,"stripe_token":"","is_enable_push_notifications":self.push,"is_enable_text_message_alert":self.textmsg,"device_token":fcmtoken,"device_id":""]
        
        let headers:HTTPHeaders? = nil
        
        let url = Constant.Baseurl + "register"
        
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
                        let data = dictionary?["data"]?.dictionary
                        
                        UserDefaults.standard.set(dictionary!["token"]!["token"].stringValue, forKey:"token")
                        UserDefaults.standard.set(data?["id"]?.intValue, forKey:"userid")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"VerifyMobileVC") as! VerifyMobileVC
                        vc.isParent = self.isParent
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        Utility.shared.showSnackBarMessage(message:(dictionary?["message"]?.string)!)
                    }
                }
                
            case .failure(let error):
                Utility.shared.stopProgress()
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
            
        }
        
    }
    
}

extension RegisterForm:GoogleAPIDelegate{
    
    func didAutoCompleteFinished(addresses: [JSON]?) {
        print(addresses.self as Any)
     
        //        let jsonObj = searchlist[indexPath.row]
        //        let placeid = jsonObj["place_id"].stringValue
        //        GoogleAPI.shared.placeDetail(placeID: placeid)
        
    }
    
    func didAutoCompleteFailed(error: String?) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    func didPlaceDetailFinished(place:[String:JSON]?) {
        print(place.self as Any)
        let name  = place?["name"]?.stringValue
        let formatted_address = place?["formatted_address"]?.stringValue
        let lAddress = name! + "," + formatted_address!
        let lat = place?["geometry"]?["location"]["lat"].stringValue
        let lng = place?["geometry"]?["location"]["lng"].stringValue
    }

    
}


extension RegisterForm: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        home_address.text = place.name
        home_lat = place.viewport?.northEast.latitude
        home_log = place.viewport?.northEast.longitude
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
        print(place.self as Any)
        
        searchTxt = place.name!
        let uuid = UUID()
        GoogleAPI.shared.autoComplete(keyword:searchTxt , session: uuid.uuidString)
        GoogleAPI.shared.delegate = self
        
        
        
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
