
//
//  EmergencyContactViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 18/10/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class EmergencyContactViewController: UIViewController {
    var datalist:[JSON] = []
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        getdata()
        tableview.tableFooterView = UIView()
        tableview.separatorStyle = .none
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
        let url =  Constant.Baseurl + "get-emergency-contact"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                let resJson = JSON(response.result.value!)
                print(resJson)
                if resJson["status"].stringValue == "true"{
                     let data = resJson["data"]
                    for i in 0..<data.count{
                        self.datalist.append(data[i])
                    }
                    self.tableview.reloadData()
                }
                
            case .failure(let _):
                self.dismiss(animated: true, completion: nil)
                break
                
            }
            
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addcontacts(_ sender: Any) {
    
    }
    
}

extension EmergencyContactViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        cell.lblname.text = datalist[indexPath.row]["related_name"].stringValue
        cell.lblphoneno.text = datalist[indexPath.row]["number"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
}
