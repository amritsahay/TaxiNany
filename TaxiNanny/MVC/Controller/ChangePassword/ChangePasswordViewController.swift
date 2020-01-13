//
//  ChangePasswordViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 18/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ChangePasswordViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var oldpeyes: UIButton!
     @IBOutlet weak var newpeyes: UIButton!
     @IBOutlet weak var cnfrnpeyes: UIButton!
    @IBOutlet weak var txtcnfrmpwd: UITextField!
    @IBOutlet weak var txtnewpswd: UITextField!
    @IBOutlet weak var textoldpswd: UITextField!
    @IBOutlet weak var imgView1: UIImageView!
    
    @IBOutlet weak var Char: UILabel!
    @IBOutlet weak var imgViewSpecialChar: UIImageView!
    @IBOutlet weak var specialChar: UILabel!
    @IBOutlet weak var imgViewUpper: UIImageView!
    @IBOutlet weak var upper: UILabel!
    @IBOutlet weak var checkbtnview: UIButton!
    @IBOutlet weak var imgViewNumber: UIImageView!
    @IBOutlet weak var atLeast: UILabel!
    var iconClick = true
    var iconClick1 = true
    var iconClick2 = true
    var uppercase = false
    override func viewDidLoad() {
        super.viewDidLoad()
        oldpeyes.tintColor = UIColor.lightGray
        newpeyes.tintColor = UIColor.lightGray
        cnfrnpeyes.tintColor = UIColor.lightGray
        txtnewpswd.delegate = self
    }
    
    @IBAction func iconAction(sender: AnyObject) {
        if(iconClick == true) {
            textoldpswd.isSecureTextEntry = false
            oldpeyes.tintColor = Constant().headerColor()
        } else {
            textoldpswd.isSecureTextEntry = true
            oldpeyes.tintColor = UIColor.lightGray
        }
        iconClick = !iconClick
    }

    @IBAction func iconAction2(_ sender: Any) {
        if(iconClick2 == true) {
            txtcnfrmpwd.isSecureTextEntry = false
            cnfrnpeyes.tintColor = Constant().headerColor()
        } else {
            txtcnfrmpwd.isSecureTextEntry = true
            cnfrnpeyes.tintColor = UIColor.lightGray
        }
        iconClick1 = !iconClick1
    }
    
    @IBAction func iconAction1(_ sender: Any) {
        if(iconClick1 == true) {
            txtnewpswd.isSecureTextEntry = false
            newpeyes.tintColor = Constant().headerColor()
        } else {
            txtnewpswd.isSecureTextEntry = true
            newpeyes.tintColor = UIColor.lightGray
        }
        iconClick2 = !iconClick2
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //test case
        
      if textField == txtnewpswd {
            //test
            if let txt = txtnewpswd.text {
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
                
                if (txtnewpswd.text?.isBlank)!
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
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func registerApiCall(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let type =  UserDefaults.standard.value(forKey:"user_type") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        
        
        let parameter = ["user_type":type,"old_pass":textoldpswd.text,"new_pass":txtcnfrmpwd.text]
        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "change-password"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                let resJson = JSON(response.result.value!)
                print(resJson)
            case .failure(let _):
                self.dismiss(animated: true, completion: nil)
                break
                
            }
            
        }
    }
    @IBAction func changepwdbtn(_ sender: Any) {
        if validation()
        {
            if let txt = textoldpswd.text {
                if ((txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil)){
                    Utility.shared.showSnackBarMessage(message:"UpperCase letter missing")
                }else{
                    registerApiCall()
                }
            }
        }
    }
    
    
    func validation() -> Bool
    {
        if textoldpswd.text == ""{
            Utility.shared.showSnackBarMessage(message:"Enter old password")
            return false
        }
        if txtnewpswd.text == "" {
            Utility.shared.showSnackBarMessage(message:"Enter new password")
            return false
        }
        if txtnewpswd.text == "" {
            Utility.shared.showSnackBarMessage(message:"Enter new password")
            return false
        }
         
        else if !(txtnewpswd.text?.isValidPassword)!
        {
            //            Utility.shared.showSnackBarMessage(message:"Please enter valid password.Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:")
            
        }
            
        else if (!(txtnewpswd.text == txtcnfrmpwd.text)){
            Utility.shared.showSnackBarMessage(message:"Password didn't match")
            return false
        }
        
        return true
    }
}
