//
//  EditCarDetailsViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 20/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import DropDown

class EditCarDetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var yearlistView: UIView!
    @IBOutlet weak var txtmodel: UITextField!
    @IBOutlet weak var lblyear: UILabel!
    
    @IBOutlet weak var txtmake: UITextField!
    @IBOutlet weak var vehicleimage: UIImageView!
    
    let dropDown = DropDown()
    var yearlist = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        vehicleimage.layer.cornerRadius = vehicleimage.frame.width / 2
//        vehicleimage.clipsToBounds = true
        getdata()
        let cdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let datestring = formatter.string(from: cdate)
        let ye = Int(datestring)!
        for i in 2000...ye{
            yearlist.append(String(i))
        }
        dropDown.anchorView = yearlistView
        dropDown.dataSource = yearlist as! [String]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lblyear.text = item
            self.yearlistView.isHidden = true
        }
        //dropDown.bottomOffset = CGPoint(x: 0, y:270)
        //dropDown.topOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        //dropDown.direction = .top
        yearlistView.isHidden = true
        
    }
    
    func getdata(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        
        

        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "VehicleDetail"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                let resJson = JSON(response.result.value!)
                if resJson["status"].stringValue == "true"{
                    let vehicle_detail = resJson["vehicle_detail"]
                    let url = URL(string: vehicle_detail["image"].stringValue)
                    self.vehicleimage.sd_setImage(with: url, completed: nil)
                    self.txtmake.text =  vehicle_detail["make"].stringValue
                    self.txtmodel.text = vehicle_detail["model"].stringValue
                    self.lblyear.text  = vehicle_detail["year"].stringValue
                }
                
            case .failure(let _):
                break
                
            }
            
        }
    }
    @IBAction func ChooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler:{(action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler:{(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let orgimage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        vehicleimage.image = orgimage
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func yeardropdown(_ sender: Any) {
        dropDown.show()
        self.yearlistView.isHidden = false
    }
    
    @IBAction func save(_ sender: Any) {
        let make = txtmake.text
        if make == "" {
            Utility.shared.showSnackBarMessage(message:"Enter make")
            return
        }
        let model = txtmodel.text
        if model == ""{
            Utility.shared.showSnackBarMessage(message: "Enter Model")
            return
        }
        let year = lblyear.text
        if year == "year"{
            Utility.shared.showSnackBarMessage(message: "Select Year")
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        
        let base64img = ConvertImageToBase64String(img: vehicleimage.image!)
        let parameter = ["make":make,"model":model,"year":year,"image":base64img]
        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "updatevehicleDetail"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                let resJson = JSON(response.result.value!)
                let msg = resJson["message"].stringValue
                Utility.shared.showSnackBarMessage(message: msg)
            case .failure(let _):
                break
                
            }
            
        }
    }
    
    func ConvertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
