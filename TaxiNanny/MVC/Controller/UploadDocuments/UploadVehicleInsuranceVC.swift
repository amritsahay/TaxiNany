//
//  UploadVehicleInsuranceVC.swift
//  TaxiNanny
//
//  Created by ip-d on 01/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UploadVehicleInsuranceVC: UIViewController {
    @IBOutlet weak var company_name: UITextField!
    @IBOutlet weak var policy_number: UITextField!
    @IBOutlet weak var valid_till: UITextField!
    @IBOutlet weak var issued_on: UITextField!
    
    let issued_on_picker = UIDatePicker()
    let valid_till_picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
        
    }
    
    func setUI()
    {
        issued_on_picker.datePickerMode = .date
        issued_on_picker.datePickerMode = .date
        issued_on.inputView = issued_on_picker
        valid_till.inputView = valid_till_picker
        
        
        issued_on.delegate = self
        valid_till.delegate = self
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func UploadPhoto(_ sender: Any) {
         // selectPhotoActionSheet()
        if validation()
        {
            selectPhotoActionSheet()
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        if validation()
        {
            //updateBack()
            selectPhotoActionSheet()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //Mark - Other Method
    
    func validation() -> Bool
    {
        if (company_name.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please fill company name.")
            return false
        }
        else if (policy_number.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please fill policy number.")
            return false
        }
        else if (issued_on.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please select date of issue.")
            return false
        }
        else if (valid_till.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please select date till valid.")
            return false
        }
        
        return true
    }
    
    func updateBack()
    {
        if let viewControllers = self.navigationController?.viewControllers
        {
            for viewController in viewControllers
            {
                if viewController.isKind(of:UploadDocumentsVC.self)
                {
                    let uploadDocumentVC = viewController as! UploadDocumentsVC
                    uploadDocumentVC.updateDocumentStatus(document_name:"Vehicle Insurance")
                    self.navigationController?.popToViewController(uploadDocumentVC, animated:true)
                    break
                }
            }
            
        }
    }
    
    
    func selectPhotoActionSheet()
    {
        let alertViewController = UIAlertController(title:"Rider Photo", message: "Please select an option.", preferredStyle: .actionSheet)
        
        let cameraAlertAction = UIAlertAction(title:"Take Photo", style: .default) { (sender) in
            self.openDeviceCamera()
            alertViewController.dismiss(animated:true, completion: nil)
        }
        alertViewController.addAction(cameraAlertAction)
        
        let libraryAlertAction = UIAlertAction(title: "Photos Library", style:.default) { (sender) in
            self.openDevicePhotoGallary()
            alertViewController.dismiss(animated: true, completion:nil)
        }
        alertViewController.addAction(libraryAlertAction)
        
        let cancelAlertAction = UIAlertAction(title:"Cancel", style: .cancel) { (sender) in
            alertViewController.dismiss(animated:true, completion:nil)
        }
        alertViewController.addAction(cancelAlertAction)
        
        self.present(alertViewController, animated: true, completion:nil)
    }
    
    func openDeviceCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            Utility.shared.showSnackBarMessage(message:"Sorry,Camera service not available.")
        }
        
    }
    
    func openDevicePhotoGallary()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            Utility.shared.showSnackBarMessage(message:"Sorry,Photos Library service not available.")
        }
    }

    
}

extension UploadVehicleInsuranceVC: UITextFieldDelegate
{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == issued_on
        {
            textField.text  = issued_on_picker.date.dateString(in: .medium)
        }
        else if textField == valid_till
        {
            textField.text  = valid_till_picker.date.dateString(in: .medium)
        }
        return true
    }
}


extension UploadVehicleInsuranceVC:UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera
        {
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
            {
                let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
             
                //self.filename.text = "document file"
            }
            
        }
        else if picker.sourceType == .photoLibrary
        {
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
            {
                let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                //self.filename.text = "document file"
            }
        }
        picker.dismiss(animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UploadVehicleInsuranceVC:UINavigationControllerDelegate
{
    
}


// webseevice
extension UploadVehicleInsuranceVC
{
    func UploadVehicleInsuranceApi(image:UIImage) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //let image = UIImage.init(named: "myImage")
        let imgData =  image.jpegData(compressionQuality: 0.75)
        
        let url = "http://178.128.116.149/taxinanny1/public/api/addinsurencedetaildriver"
        
        let date = self.issued_on.text
        let expiredate = self.valid_till.text
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(("2".data(using: String.Encoding.utf8))!, withName: "driver_id")
                
                multipartFormData.append(("1".data(using: String.Encoding.utf8))!, withName: "vehicle_id")
                
                multipartFormData.append("1".data(using:String.Encoding.utf8)!, withName:"company_name")
                
                multipartFormData.append("1".data(using:String.Encoding.utf8)!, withName:"policy_no")
                
                multipartFormData.append((date!.data(using: String.Encoding.utf8)!), withName:"issued_on" )
                
                multipartFormData.append((expiredate!.data(using: String.Encoding.utf8))!, withName: "expiry_date")
                
                multipartFormData.append(imgData!, withName: "image")
        },
            to: url,
            method:.post,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        // Utility.shared.stopProgress()
                        print("Validation Successful")
                        let jsonString = response.value?.replacingOccurrences(of:"mu-plugins/query-monitor/wp-content/db.php", with:"")
                        let json = JSON.init(parseJSON:jsonString ?? "{}")
                        let response = json.dictionary
                        let status = response?["status"]?.stringValue
                        if status == "ok"
                        {
                            self.updateBack()
                        }
                        else
                        {
                            //                            Utility.shared.showSnackBarMessage(message:(response?["error"]?.stringValue)!)
                        }
                        
                    }
                case .failure(let encodingError):
                    //Utility.shared.stopProgress()
                    print(encodingError)
                    Utility.shared.showSnackBarMessage(message:encodingError.localizedDescription)
                }
        }
        )
        
    }
    
}

