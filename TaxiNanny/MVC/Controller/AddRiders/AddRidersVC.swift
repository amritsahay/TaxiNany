//
//  AddRidersVC.swift
//  TaxiNanny
//
//  Created by ip-d on 15/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class AddRidersVC: UIViewController {
    
    @IBOutlet weak var all_checked: UIButton!
    @IBOutlet weak var list_view: UITableView!
    @IBOutlet weak var btn_view: BorderView!
    
    @IBOutlet weak var deletebtn: UIButton!
    @IBOutlet weak var nextbtn: UIButton!
    
    
    var riderlist:[JSON] = []
    var selectedriderlist:[JSON] = []
    var Checked = true
    
    var selected:[String:String] = [:]
    var deleteRidersid:[String:Any]=[:]
    var deleteRiderslist:[AnyObject] = []
    var deleteRidersListJson:JSON = []
    
    var list:Array<JSON> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        deletebtn.isHidden = true
        btn_view.isHidden = true
        setUI()
        
    }
    
    func setUI()
    {
        list_view.register(UINib(nibName:"RiderCell", bundle:nil), forCellReuseIdentifier:"RiderCell")
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        riderListApiCall()
        Checked = true
    }
   
    
    @IBAction func addRiders(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"RiderForm1")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func all_checked(_ sender: Any) {
        
        if(Checked == true) {
            for (index,value) in riderlist.enumerated(){
                selectedriderlist.append(riderlist[index])
                var id = riderlist[index]["id"].stringValue
                selected[String(index)] = id
            }
            all_checked.setImage(UIImage(named: "checked-flat"), for: .normal)
            deletebtn.isHidden = false
            btn_view.isHidden = false
            
        } else {
            all_checked.setImage(UIImage(named: ""), for: .normal)
            deletebtn.isHidden = true
            btn_view.isHidden = true
            selected.removeAll()
            selectedriderlist.removeAll()
        }
        Checked = !Checked
        list_view.reloadData()

    }
    
    @IBAction func back(_ sender: Any) {
        // self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        CommmanFunction.setriderdetails(data: JSON(selectedriderlist))
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedRiderVC") as! SelectedRiderVC
        vc.riderlist = selectedriderlist
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     @IBAction func deleteRider(_ sender: Any) {
      // Utility.shared.showSnackBarMessage(message:"under construction!!")
        for i in selectedriderlist{
            //deleteRidersid = i["id"].stringValue
            deleteRidersid = ["rider_id":i["id"].stringValue]
            deleteRiderslist.append(deleteRidersid as AnyObject)
            //deleteRidersListJson.appendIfArray(json: JSON(["ride_detail":deleteRiderslist]))
           self.list.append(["rider_id":deleteRidersid])
        }
           self.deleteriderApiCall()
     }
    
    func loadImageWith(imgView: UIImageView, url: String?) {
        
        imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        if url != nil {
            imgView.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: "download.png"), options:SDWebImageOptions.scaleDownLargeImages, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
                
                if ((error) != nil) {
                    imgView.image = UIImage.init(named: "user1")
                }
            })
        }
        else{
            imgView.image = UIImage.init(named: "user1")
        }
    }
    
}

extension AddRidersVC:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riderlist.count
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"RiderCell", for: indexPath) as! RiderCell
        cell.selectionStyle = .none
        
        let id = "\(indexPath.row)"
        //  cell.photo_view
        //  cell.rider_name
        //  cell.checkButton
        
        let jsonObj = riderlist[indexPath.row]
        let imgPath =  jsonObj["image"].stringValue
    
        if !imgPath.isEmpty {
            //let imgUrlStr = imgUrl+"/"+imgPath!
            loadImageWith(imgView: cell.photo_view, url: imgPath)
        }
        
        let first =  jsonObj["first_name"].stringValue
        let last = jsonObj["last_name"].stringValue
        let name = first+" "+last
        cell.rider_name.text = name
        
        if (selected[id] != nil || Checked == false )
        {
            deletebtn.isHidden = false
            btn_view.isHidden = false
            cell.checkButton.setImage(UIImage(named: "checked-flat"), for: .normal)
        }
        else
        {
            cell.checkButton.setImage(UIImage(named: ""), for: .normal)
            if selected.count == 0{
                deletebtn.isHidden = true
                btn_view.isHidden = true
            }
        }
        
        return cell
    }
    
}

extension AddRidersVC:UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedRiderVC") as! SelectedRiderVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        let id = "\(indexPath.row)"
        
        if (selected[id] != nil)
        {
            
            var count = 0
            for i in selectedriderlist{
                if i["id"].stringValue == selected[id]{
                    selectedriderlist.remove(at: count)
                    break
                }
                count = count + 1
            }
            selected.removeValue(forKey:id)
            all_checked.setImage(UIImage(named: ""), for: .normal)
            if selected.count == 0{
            deletebtn.isHidden = true
            btn_view.isHidden = true
            }
            Checked = true
        }
        else{
             selected[id] = riderlist[indexPath.row]["id"].stringValue
            selectedriderlist.append(riderlist[indexPath.row])
            let jsonObj = riderlist[indexPath.row]
            let id =  jsonObj["id"].intValue
            Checked = false
            print(deleteRiderslist)

        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}

// webseevice
extension AddRidersVC
{
    func riderListApiCall() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Utility.shared.startProgress(message:"Please wait.")
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            headerValue = finalToken
        }
        
        let parameter:Parameters = [:]
        let headers:HTTPHeaders? = ["Authorization":headerValue]
       
        let url =  Constant.Baseurl + "riderList/" + String(parentid)
        
        Alamofire.request(url, method: .get, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
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
                        //
                        self.riderlist = (dictionary?["data"]!.arrayValue)!
                        
                        if (self.riderlist.isEmpty) {
                            self.btn_view.isHidden = true
                            self.nextbtn.isHidden = true
                        }else{
                            self.btn_view.isHidden = false
                            self.nextbtn.isHidden = false
                        }
                        
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
    
    // Delete rider
    func deleteriderApiCall() {
       
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let parameters: Parameters = ["ride_detail": deleteRiderslist]
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
       
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = Constant.deletetoken
        }
        
        
      
        let headers:HTTPHeaders? = ["Authorization":finalToken,"Accept":"application/json"]
            let url = Constant.Baseurl + "deleterider"
            
            Utility.shared.startProgress(message:"Please wait.")
       
        //json
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).validate().responseString { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                Utility.shared.stopProgress()
                switch response.result {

                case .success:

                    print(response.result)
                    let responseJSON = JSON(response.result.value!)
                    if responseJSON.stringValue.contains("true"){
                        self.all_checked.setImage(UIImage(named: ""), for: .normal)
                        self.deleteRidersid = [:]
                        self.deleteRiderslist = []
                        self.selected.removeAll()
                        self.Checked = true
                        self.selectedriderlist.removeAll()
                        Utility.shared.showSnackBarMessage(message:"Rider deleted successfully.")
                        self.riderListApiCall()
                    }
                case .failure(let error):
                    Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                    print(error)
                }


            }
        
        }
        
   
    func jsonEncode(object: Any?) -> Data? {
        if let object = object {
            return try? JSONSerialization.data(withJSONObject: object, options:[])
        }
        return nil
    }
    
    
}
extension JSON{
    mutating func appendIfArray(json:JSON){
        if var dict = self.array{
            dict.append(json)
            
        }
    }
    
}
