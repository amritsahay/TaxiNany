//
//  SelectVehicleTypeVC.swift
//  TaxiNanny
//
//  Created by ip-d on 25/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SelectVehicleTypeVC: UIViewController {
    
    @IBOutlet weak var list_view: UITableView!
    var selected:UInt = 0
    
   // var vehicles_type = ["Mirco","Sedan","SUV"]
    
    var vehicles_type:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
    }
    
    @IBAction func continue_action(_ sender: Any) {
        let button = sender as! UIButton
        let object  = vehicles_type[button.tag]
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"AddVehicleDetails") as! AddVehicleDetails
        vc.object = object
        self.navigationController?.pushViewController(vc, animated:true)
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUI()
    {
        list_view.register(UINib.init(nibName:"VehicleTypeViewCell", bundle:nil), forCellReuseIdentifier:"VehicleTypeViewCell")
        vehicleTypeDetaisApi()
    }
    
}

extension SelectVehicleTypeVC:UITableViewDelegate
{
    @objc func expand(button:UIButton) {
        selected = UInt(button.tag)
        list_view.reloadData()
    }
}

extension SelectVehicleTypeVC:UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vehicles_type.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == selected
        {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"VehicleTypeViewCell", for:indexPath) as! VehicleTypeViewCell
        
        let jsonObj = vehicles_type[indexPath.row]
        cell.message.text = jsonObj["description"].stringValue
        cell.count.text = jsonObj["capacity"].stringValue
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = VehicleTypeView()
        let jsonObj = vehicles_type[section]
        header.car_name.text = jsonObj["type"].stringValue
        //header.car_name.text = vehicles_type[section]
        header.button.addTarget(self, action: #selector(expand(button:)), for:.touchUpInside)
        header.button.tag = section
        if selected == section { header.check.isHidden = false
            header.car_image.tintColor = Constant().headerColor()
        }
        else { header.check.isHidden = true
            header.car_image.tintColor = UIColor.gray
        }
       // type
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 63.00
    }
}

// webseevice
extension SelectVehicleTypeVC
{
    func vehicleTypeDetaisApi() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            headerValue = finalToken
        }
        
        let parameter:Parameters = [:]
        let headers:HTTPHeaders? = ["Authorization":headerValue]
        
        let url = "http://178.128.116.149/taxinanny1/public/api/getvehicletype"
        
        Alamofire.request(url, method: .get, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                
                print(response.result)
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "true"
                    {
                       //
                        self.vehicles_type = (dictionary?["data"]!.arrayValue)!
                        self.list_view.reloadData()
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
