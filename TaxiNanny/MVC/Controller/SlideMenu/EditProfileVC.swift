//
//  EditProfileVC.swift
//  TaxiNanny
//
//  Created by ip-d on 25/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
import GooglePlaces

class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var txthome: UITextField!
    @IBOutlet weak var txtphone: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtlastname: UITextField!
    @IBOutlet weak var txtfirstname: UITextField!
    var locationlist = [FavouriteLocationListModel]()
    var home_lat:Double?
    var home_log:Double?
     var searchTxt = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "PlacesTableViewCell")
        getdata()
        getlocation()
        txtemail.isUserInteractionEnabled = false
        txthome.delegate = self
        txthome.addTarget(self, action: #selector(placeSearch), for: .touchDown)
    }
    
    func getlocation(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            headerValue = finalToken
        }
        
        let headers = ["Authorization":headerValue]
        let url = Constant.Baseurl + "FavouriteLocationList/" + String(parentid)
        Utility.shared.startProgress(message:"Please wait.")
        Alamofire.request(url, method: .get, encoding:JSONEncoding.default, headers: headers).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                Utility.shared.stopProgress()
                print(response.result)
                let responseJSON = JSON(response.result.value!)
                if let status = responseJSON["status"].string
                {
                    if status == "true"
                    {
                        let data = responseJSON["data"]
                        
                        for i in data.arrayValue{
                            self.locationlist.append(FavouriteLocationListModel(json: i))
                        }
                        self.tableview.reloadData()
                    }
                    else
                    {
                        
                    }
                }
            case .failure(let error):
                Utility.shared.stopProgress()
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
        }
        
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
        let parameter = ["id":parentid]
        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "userdetails/" + String(parentid)
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                let resJson = JSON(response.result.value!)
                let msg = resJson["message"].stringValue
                if resJson["status"] == "true"{
                    let data = resJson["data"]
                    self.txtemail.text = data["email"].stringValue
                    self.txtfirstname.text = data["first_name"].stringValue
                    self.txtlastname.text = data["last_name"].stringValue
                    self.txthome.text = data["address"].stringValue
                    self.txtphone.text = data["phone_no"].stringValue
                    let url = URL(string: data["image"].stringValue)
                    self.userimage.sd_setImage(with: url, completed: nil)
                }else{
                    Utility.shared.showSnackBarMessage(message: msg)
                }
            case .failure(let _):
                break
                
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        searchTxt = textField.text!
        //        let uuid = UUID()
        //        GoogleAPI.shared.autoComplete(keyword:searchTxt , session: uuid.uuidString)
        //        GoogleAPI.shared.delegate = self
        if textField == txthome{
            txthome.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    @objc func placeSearch(textField: UITextField) {
        if textField == txthome{
            txthome.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
       dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func save(_ sender: Any) {
        let firstname = txtfirstname.text
        if firstname == ""{
            Utility.shared.showSnackBarMessage(message: "Plesae Enter First Name")
            return
        }
        let lastname = txtlastname.text
        if lastname == ""{
            Utility.shared.showSnackBarMessage(message: "Plesae Enter Last Name")
            return
        }
        let phone = txtphone.text
        if phone == ""{
            Utility.shared.showSnackBarMessage(message: "Plesae Enter Phone Number")
            return
        }
        let address = txthome.text
        if address == ""{
            Utility.shared.showSnackBarMessage(message: "Plesae choose home address")
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let base64img = ConvertImageToBase64String(img: userimage.image!)
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let user_id = String(parentid)
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        let parameter = ["first_name":firstname,"last_name":lastname,"phone_no":phone,"user_id":user_id,"image":base64img]
        let headers = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "updateuserdetails"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                let resJson = JSON(response.result.value!)
                let msg = resJson["message"].stringValue
                if resJson["status"] == "true"{
                   Utility.shared.showSnackBarMessage(message: msg)
                }else{
                   Utility.shared.showSnackBarMessage(message: msg)
                }
            case .failure(let _):
                break
                
            }
            
        }
    }
    
    func ConvertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    @IBAction func choosepic(_ sender: Any) {
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
        userimage.image = orgimage
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "PlacesTableViewCell") as! PlacesTableViewCell
        cell.lblsubloc.text = locationlist[indexPath.row].nick_name
        cell.lbllocation.text = locationlist[indexPath.row].location_name
        cell.celldeligate = self
        cell.index = indexPath
        cell.id = locationlist[indexPath.row].id
        return cell
    }
    
    
}
extension EditProfileVC:TableViewPlace{
    func OnClick(index: Int,id: String) {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditFavouriteLocationVC") as! EditFavouriteLocationVC
        vc.var_loc = locationlist[index].location_name
        vc.var_note = locationlist[index].description
        vc.var_nike = locationlist[index].nick_name
        vc.id = id
        vc.lat = locationlist[index].lattitude
        vc.long = locationlist[index].longitude
        self.present(vc, animated: true, completion: nil)
        
    }
}

extension EditProfileVC:GoogleAPIDelegate{
    
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


extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        txthome.text = place.name
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


