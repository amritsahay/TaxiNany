//
//  RiderForm1.swift
//  TaxiNanny
//
//  Created by ip-d on 17/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Timepiece

class RiderForm1: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var date_of_birth: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var first_name: UITextField!
    
    let DOBPicker = UIDatePicker()
    let genderPicker = UIPickerView()
    let gender_data = ["Male","Female","Do not prefer to answer"]
    
    var rider = RiderModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    //Mark:- button methods
    
    @IBAction func back(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        if validateInputs()
        {
            rider.firstName = first_name.text
            rider.lastName = last_name.text
            rider.dob = date_of_birth.text
            rider.gender = Utility.shared.getGenderValue(string:gender.text!)
            
            let rider_form = self.storyboard?.instantiateViewController(withIdentifier:"RiderForm2") as! RiderForm2
            rider_form.rider = rider
            self.navigationController?.pushViewController(rider_form, animated:true)
        }
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        selectPhotoActionSheet()
    }
    
    //Mark :- others methods
    
    func setUI()
    {
        genderPicker.delegate = self
        genderPicker.dataSource = self
        gender.inputView = genderPicker
        DOBPicker.datePickerMode = .date
        //DOBPicker.maximumDate = Date() - 1
        date_of_birth.delegate = self
        date_of_birth.inputView = DOBPicker
        datepicker()
        first_name.delegate = self
        last_name.delegate = self
    }
    
    func datepicker()  {
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.day = -1
        let maxDate = calendar.date(byAdding: comps, to: Date())
        DOBPicker.maximumDate = maxDate
        
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
            imagePicker.allowsEditing = true
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
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            Utility.shared.showSnackBarMessage(message:"Sorry,Photos Library service not available.")
        }
    }
    
    func validateInputs() -> Bool
    {
        if (first_name.text?.isBlank)! {
            Utility.shared.showSnackBarMessage(message:"Please fill first name.")
            return false
        }
        else if !(first_name.text?.isAlphabets)! {
            Utility.shared.showSnackBarMessage(message:"Please use only alphabets in first name.")
            return false
        }
        else if (last_name.text?.isBlank)!{
            Utility.shared.showSnackBarMessage(message:"Please fill last name.")
            return false
        }
        else if !(last_name.text?.isAlphabets)! {
            Utility.shared.showSnackBarMessage(message:"Please use only alphabets in last name.")
            return false
        }
        else if (date_of_birth.text?.isBlank)! {
            Utility.shared.showSnackBarMessage(message:"Please select date of birth.")
            return false
        }
        else if (gender.text?.isBlank)!{
            Utility.shared.showSnackBarMessage(message:"Please select any gender.")
            return false
        }
        return true
    }
    
    func clearUI()
    {
        rider = RiderModel()
        first_name.text = ""
        last_name.text = ""
        date_of_birth.text = ""
        gender.text = ""
        photo.image = nil
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    
}

extension RiderForm1:UITextFieldDelegate
{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if date_of_birth == textField
        {
            // textField.text = DOBPicker.date.dateString(in: .medium)
            //test
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let selectedDate = dateFormatter.string(from: DOBPicker.date)
            let currentdate = dateFormatter.string(from: date)
            if (currentdate == selectedDate){
                Utility.shared.showSnackBarMessage(message:"Current date not allowed")
                
            }else{
            textField.text = formattedDateFromString(dateString: selectedDate, withFormat: "yyyy-MM-dd")
            }
        }
        return true
    }
    
    //text limit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}

extension RiderForm1:UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender_data[row]
    }
    
}

extension RiderForm1:UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender.text = gender_data[row]
    }
}

extension RiderForm1:UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera
        {
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
            {
                let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                photo.image = selectedPhoto
            }
            
        }
        else if picker.sourceType == .photoLibrary
        {
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
            {
                let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                photo.image = selectedPhoto
            }
        }
        picker.dismiss(animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RiderForm1:UINavigationControllerDelegate
{
    
}

extension Utility
{
    func getGenderValue(string:String) -> String
    {
        switch string {
        case "Male":
            return "1"
        case "Female":
            return "2"
        default:
            return "0"
        }
    }
    
    func getGenderString(value:String) -> String
    {
        switch value {
        case "1":
            return "Male"
        case "2":
            return "Female"
        default:
            return "Do not prefer to answer"
        }
    }
    
}
