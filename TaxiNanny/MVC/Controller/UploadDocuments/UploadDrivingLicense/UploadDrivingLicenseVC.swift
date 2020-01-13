//
//  UploadDrivingLicenseVC.swift
//  TaxiNanny
//
//  Created by ip-d on 31/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UploadDrivingLicenseVC: UIViewController {
    
    @IBOutlet weak var issued_date: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var full_name: UITextField!
    @IBOutlet weak var licenseNumber: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var expireDate: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var year: UITextField!
    
    let countryPicker = UIPickerView()
    let issuedDatePicker  = UIDatePicker()
    let dateOfBirthPicker  = UIDatePicker()
    let expirationDatePicker  = UIDatePicker()
    let cityPicker = UIPickerView()
    let statePicker = UIPickerView()
    
    var selectedCountries:Dictionary<String, Any> = Dictionary()
    var selectedState:Dictionary<String, Any> =  Dictionary()
    var selectedCity:[String] = []
    
    
    let yearPicker = TLMonthYearPickerView(frame: CGRect(x: 0, y: 0, width:0, height: 160))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // Mark - Button Methods
    
    @IBAction func Submit(_ sender: Any) {
        if validation()
        {
            //updateBack()
            selectPhotoActionSheet()
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func UploadPhoto(_ sender: Any) {
        
        if validation()
        {
            selectPhotoActionSheet()
        }
        
    }
    
    // Mark - Other Methods
    
    func validation() -> Bool
    {
        if (full_name.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please fill full name.")
            return false
        }
        else if (country.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please select the country.")
            return false
        }
        else if (issued_date.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please select the issued on date.")
            return false
        }
        else if (licenseNumber.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please fill license number.")
            return false
        }
        else if (dateOfBirth.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message: "Please fill date of birth.")
            return false
        }
        else if (expireDate.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please fill date of expire.")
            return false
        }
        else if (address1.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message: "Please fill address1.")
            return false
        }
        else if (address2.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message: "Please fill address2.")
            return false
        }
        else if (state.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please select the state.")
            return false
        }
        else if (city.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please select the city.")
            return false
        }
        else if (year.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please select the year.")
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
                    uploadDocumentVC.updateDocumentStatus(document_name:"Driver License")
                    self.navigationController?.popToViewController(uploadDocumentVC, animated:true)
                    break
                }
            }
            
        }
        
    }
    
    func setUI()
    {
        initYearControl()
        initPicker()
    }
    
    func initYearControl()
    {
        yearPicker.calendar = Calendar(identifier: .gregorian)
        yearPicker.monthYearPickerMode = .year
        yearPicker.maximumDate = Date()
        yearPicker.delegate = self
        year.inputView = yearPicker
    }
    
    func initPicker()
    {
        countryPicker.delegate = self
        cityPicker.delegate = self
        statePicker.delegate = self
        issued_date.delegate  = self
        dateOfBirth.delegate = self
        expireDate.delegate = self
        
        
        issued_date.inputView = issuedDatePicker
        dateOfBirth.inputView = dateOfBirthPicker
        expireDate.inputView =  expirationDatePicker
        
        issuedDatePicker.datePickerMode = .date
        dateOfBirthPicker.datePickerMode = .date
        expirationDatePicker.datePickerMode = .date
        
        
        country.inputView = countryPicker
        city.inputView = cityPicker
        state.inputView = statePicker
        
        
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
extension UploadDrivingLicenseVC:TLMonthYearPickerDelegate
{
    func monthYearPickerView(picker: TLMonthYearPickerView, didSelectDate date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from:date)
    }
}

extension UploadDrivingLicenseVC:UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPicker
        {
            return CountriesClass.shared.list?.count ?? 0
        }
        else if pickerView == statePicker
        {
            if ((selectedCountries["states"] as? Dictionary<String, Any>) != nil)
            {
                selectedState = (selectedCountries["states"] as? Dictionary<String, Any>)!
                let states_array = Array(selectedState.keys)
                return states_array.count
            }
            return 0
        }
        else
        {
            if ((selectedState[state.text!] as? [String]) != nil)
            {
                selectedCity = selectedState[state.text!] as! [String]
                return selectedCity.count
            }
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPicker
        {
            return CountriesClass.shared.list![row]["name"] as? String
        }
        else if pickerView == statePicker
        {
            let states_array = Array(selectedState.keys)
            return states_array[row]
        }
        else
        {
            return selectedCity[row]
        }
    }
    
    
}

extension UploadDrivingLicenseVC:UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPicker
        {
            selectedCountries = CountriesClass.shared.list![row]
            country.text = CountriesClass.shared.list![row]["name"] as? String
            state.text = ""
            city.text = ""
        }
        else if pickerView == statePicker
        {
            selectedState = selectedCountries["states"] as! Dictionary<String, Any>
            let states_array = Array(selectedState.keys)
            state.text = states_array[row]
            city.text = ""
        }
        else
        {
            selectedCity = selectedState[state.text!] as! [String]
            city.text = selectedCity[row]
        }
    }
}

extension UploadDrivingLicenseVC:UITextFieldDelegate
{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if issued_date == textField
        {
            textField.text = issuedDatePicker.date.dateString(in: .medium)
        }
        else if expireDate == textField
        {
            textField.text = expirationDatePicker.date.dateString(in: .medium)
        }
        else if dateOfBirth == textField
        {
            textField.text = dateOfBirthPicker.date.dateString(in: .medium)
        }
        return true
    }
    
    
    
}

// webseevice
extension UploadDrivingLicenseVC
{
    func UploadDrivingLicenseApi(image:UIImage) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //let image = UIImage.init(named: "myImage")
        let imgData =  image.jpegData(compressionQuality: 0.75)
   
        let url = "http://178.128.116.149/taxinanny1/public/api/addlicencedetaildriver"
        
        let date = self.issued_date.text
        let expiredate = self.expireDate.text
        
        Utility.shared.startProgress(message:"Please wait.")
        let userid =  UserDefaults.standard.value(forKey:"userid") as? Int
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(("\(userid)".data(using: String.Encoding.utf8))!, withName: "driver_id")
                
                multipartFormData.append(("1".data(using: String.Encoding.utf8))!, withName: "vehicle_id")
                
                multipartFormData.append("1".data(using:String.Encoding.utf8)!, withName:"valid_vehicle_type")
                
                multipartFormData.append((date!.data(using: String.Encoding.utf8)!), withName:"issued_on" )
                
                multipartFormData.append((expiredate!.data(using: String.Encoding.utf8))!, withName: "expiry_date")
                
                multipartFormData.append(imgData!, withName: "image")
        },
            to: url,
            method:.post,
            encodingCompletion: { encodingResult in
                Utility.shared.stopProgress()
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        
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

extension UploadDrivingLicenseVC:UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera
        {
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
            {
                let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                //  self.filename.text = "document file"
                UploadDrivingLicenseApi(image: selectedPhoto!)
            }
            
        }
        else if picker.sourceType == .photoLibrary
        {
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
            {
                let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                // self.filename.text = "document file"
                UploadDrivingLicenseApi(image: selectedPhoto!)
            }
        }
        picker.dismiss(animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UploadDrivingLicenseVC:UINavigationControllerDelegate
{
    
}

