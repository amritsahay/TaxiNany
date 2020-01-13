//
//  PickupLocation.swift
//  TaxiNanny
//
//  Created by ip-d on 07/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import SwiftyJSON
import GooglePlaces
import Alamofire

class PickupLocation: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var list_view: UITableView!
     var locationlist = [FavouriteLocationListModel]()
     var searchTxt = ""
     var searchlist:[JSON] = []
     var terms:[JSON] = []
     var riderid :Int!
    var riderlist:[JSON] = []
    var location = {}
    var setforall:Bool = false
    var indexpick:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let count = riderlist.count-1
//        for i in 0...count{
//            riderlist[i]["droplocation"] = ""
//            riderlist[i]["pickuploaction"] = ""
//        }
//        CommmanFunction.setriderdetails(data: JSON(riderlist))
        setUI()
        self.getData()
        
    }
    
    func getData(){

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
    //let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        if let _ = token1, !token1!.isEmpty {
    /* string is not blank */
            headerValue = finalToken
        }

        let headers = ["Authorization":headerValue]
        let url = Constant.Baseurl + "FavouriteLocationList/" + String(riderid)
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
                        self.list_view.reloadData()
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
    
    func setUI()
    {
        list_view.register(UINib(nibName:"PickUpLocationCell", bundle:nil), forCellReuseIdentifier:"PickUpLocationCell")
        self.list_view.separatorStyle = UITableViewCell.SeparatorStyle.none
        search.delegate = self
        search.addTarget(self, action: #selector(placeSearch), for: .touchDown)
    }
    
    // Marks - Button Method
    
    @IBAction func back(_ sender: Any) {
        // self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
   
    @objc func placeSearch(textField: UITextField) {
      
        search.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
 
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        searchTxt = textField.text!
//        let uuid = UUID()
//        GoogleAPI.shared.autoComplete(keyword:searchTxt , session: uuid.uuidString)
//        GoogleAPI.shared.delegate = self
        
        search.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
  }

}

extension PickupLocation:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchlist.count == 0 {
            return locationlist.count
        }else{
            return searchlist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PickUpLocationCell", for: indexPath) as! PickUpLocationCell
        //value
        if searchlist.count == 0 {
            cell.title.text = locationlist[indexPath.row].nick_name
            cell.description1.text = locationlist[indexPath.row].location_name
        }else{
            let jsonObj = searchlist[indexPath.row]
            terms = jsonObj["terms"].arrayValue
            print(terms)
            if terms != nil {
                
                let jsonObj1 = terms[0]
                cell.title.text = jsonObj1["value"].stringValue
                cell.description1.text = jsonObj["description"].stringValue
                
            }
            
        }
       
        return cell
        
    }
}

extension PickupLocation:UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let riderDetailForm = self.storyboard?.instantiateViewController(withIdentifier:"RiderDetailForm") as! RiderDetailForm
//        self.navigationController?.pushViewController(riderDetailForm, animated:true)
//
        if searchlist.count == 0 {
            let location = locationlist[indexPath.row].location_name
            let lattitude = locationlist[indexPath.row].lattitude
            let longitude = locationlist[indexPath.row].longitude
            let id = locationlist[indexPath.row].id
            if setforall{
                CommmanFunction.updateforallpickup(index: riderlist.count, value: location, lat: lattitude, long: longitude,pick_id:id)
            }else{
                CommmanFunction.updatepickup(index: indexpick, value: location, lat: lattitude, long: longitude,pick_id:id)
            }
            //self.dismiss(animated: true, completion: nil)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedRiderVC") as! SelectedRiderVC
//            vc.alert = false
           self.navigationController?.popViewController(animated: true)
        }else{
            let jsonObj = searchlist[indexPath.row]
            let placeid = jsonObj["place_id"].stringValue
            GoogleAPI.shared.placeDetail(placeID: placeid)
        }
       

    }
}

extension PickupLocation:GoogleAPIDelegate{

    func didAutoCompleteFinished(addresses: [JSON]?) {
        print(addresses.self as Any)
        self.searchlist = addresses!
        
        if searchlist.count > 0 {
            list_view.reloadData()
        }
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
      
        self.dismiss(animated: true, completion: nil)
        let riderDetailForm = self.storyboard?.instantiateViewController(withIdentifier:"RiderDetailForm") as! RiderDetailForm
        riderDetailForm.riderid = riderid
        riderDetailForm.placeDetail = place
        riderDetailForm.riderlist = riderlist
        riderDetailForm.setforall = self.setforall
        riderDetailForm.indexdrop = self.indexpick
        riderDetailForm.callby = "pick"
        self.navigationController?.pushViewController(riderDetailForm, animated:true)
    }

}


extension PickupLocation: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        search.text = place.name
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
