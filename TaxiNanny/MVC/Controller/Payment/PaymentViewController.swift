//
//  PaymentViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 09/10/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PaymentViewController: UIViewController {

    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var conformView: CardView!
    @IBOutlet weak var payamoutbtn: UIButton!
    @IBOutlet weak var CardTableView: UITableView!
    var carddata:[JSON] = []
    var delete:Bool = false
    var btnhide:Bool = false
    var selected:Bool = false
    var index:Int = 0
    var date:String = ""
    var time:String = ""
    var estimatePrice:String = ""
    var amount:Double = 0
    var card_id:String = ""
    var bookingdetails = CommmanFunction.getriderdetails()
    var bookingRiderslist:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CardTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        getdata()
        if btnhide{
            payamoutbtn.isHidden = true
        }
        payamoutbtn.setTitle("Pay Amount :" + estimatePrice, for: .normal)
        conformView.isHidden = true
    }
    
    func getdata(){
        
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
        
        let headers = ["Authorization":headerValue]
        
        let url =  Constant.Baseurl + "cards"
        
        Alamofire.request(url, method: .get,encoding:JSONEncoding.default, headers: headers).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                let responseJSON = JSON(response.result.value!)
                let data = responseJSON["cards"]
                for i in 0..<data.count{
                    self.carddata.append(JSON(data[i]))
                }
                self.CardTableView.reloadData()
            case .failure(let error):
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
        }
    }
    
    @IBAction func addcard(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewcontrol:AddCardDetailsViewController = storyboard.instantiateViewController(withIdentifier: "AddCardDetailsViewController") as! AddCardDetailsViewController
        
        self.present(viewcontrol, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pay(_ sender: Any) {
        bookingApi()
    }
    
    
    @IBAction func bookbtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"ParentHomeVC") as! ParentHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func bookingApi() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            headerValue = finalToken
        }
        
        for i in 0..<bookingdetails.count{
            let riderLocation = [ "priority_drop": "1",
                                  "priority_pick": "1",
                        "rider_drop_location_id":bookingdetails[i].rider_drop_location_id,
                        "rider_id": bookingdetails[i].id,"rider_pick_location_id": bookingdetails[i].rider_pick_location_id]
            self.bookingRiderslist.append(riderLocation as AnyObject)
        }
        
       
        //test
        
//        let jsonData = try? JSONSerialization.data(withJSONObject: riderLocation, options: [])
//        let jsonString = String(data: jsonData!, encoding: .utf8)
        let am = String(amount)
        let parameter:Parameters = ["time_of_ride":self.time,"booking_date":self.date,"amount": am, "booking_end_date" : self.date,"card_id":self.card_id,
                                    "parent_id" : parentid, "booking_type" : "1", "currency" : "USD",
                                    "RideRecurringDaysList": [],
                                    "ride_detail" : bookingRiderslist,
                                    "token" : "tok_1ExWoTC4hWTqQmtYOOY2JAAu"]
        
        let finaljsonData = try? JSONSerialization.data(withJSONObject: parameter, options: [])
        let finaljson = String(data: finaljsonData!, encoding: .utf8)
        
        print(finaljson!)
        
        let headers:HTTPHeaders? = ["Authorization":headerValue]
        
        let url = Constant.Baseurl + "bookNow"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                Utility.shared.stopProgress()
                print(response.result)
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                let msg  = dictionary?["message"]?.stringValue
                if let status = dictionary?["status"]?.stringValue
                {
                    if status == "true"
                    {
                        //
                        let selectRider = self.storyboard?.instantiateViewController(withIdentifier:"PickupArrivingVC") as! PickupArrivingVC
                        self.navigationController?.pushViewController(selectRider, animated:true)
                    }
                    else
                    {
                      self.conformView.isHidden = false
                      self.msg.text = msg
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingPopupViewController") as! BookingPopupViewController
//                        vc.msg = msg!
//                        self.navigationController?.pushViewController(vc, animated: true)
//
                    }
                }
                
            case .failure(let error):
                Utility.shared.stopProgress()
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
        }
    }
    
}

extension PaymentViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentTableViewCell = CardTableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        let cardnumber = carddata[indexPath.row]["card_number"].intValue
        let a = cardnumber % 10000
        cell.lblcardno.text = "****  ****  ****  " + String(a)
        cell.lblexpirydate.text = carddata[indexPath.row]["expiry_date"].stringValue
        cell.lblcardname.text = carddata[indexPath.row]["card_holder_name"].stringValue
        if delete{
            cell.btnselect.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        }else{
            if selected{
                if indexPath.row == self.index{
                    cell.btnselect.setImage(#imageLiteral(resourceName: "select"), for: .normal)
                }else{
                    cell.btnselect.setImage(#imageLiteral(resourceName: "success"), for: .normal)
                }
            }else{
                cell.btnselect.setImage(#imageLiteral(resourceName: "success"), for: .normal)
            }
            
        }
        //cell.btnselect.addTarget(self, action: #selector(click), for: .touchUpInside)
        cell.celldeligate = self
        cell.index = indexPath
        cell.id = carddata[indexPath.row]["id"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
   
    
}

extension PaymentViewController:TableViewButton{
    func OnClick(index: Int,id: String) {
        if delete{
            Utility.shared.startProgress(message:"Please wait.")
            let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
            let token1 =  UserDefaults.standard.value(forKey:"token") as? String
            let finalToken = "Bearer "+token1!
            var headerValue = ""
            
            if let _ = token1, !token1!.isEmpty {
                /* string is not blank */
                headerValue = finalToken
            }
            
            let headers = ["Authorization":headerValue]
            
            let url =  Constant.Baseurl + "card/delete/\(id)"
            
            Alamofire.request(url, method: .get,encoding:JSONEncoding.default, headers: headers).responseJSON { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                Utility.shared.stopProgress()
                switch response.result {
                case .success:
                    let responseJSON = JSON(response.result.value!)
                    let msg = responseJSON["message"].stringValue
                    Utility.shared.showSnackBarMessage(message:msg)
                    self.carddata.remove(at: index)
                    self.CardTableView.reloadData()
                case .failure(let error):
                    Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                    print(error)
                }
            }
        }else{
            self.selected = true
            self.index = index
            self.card_id = id
            self.CardTableView.reloadData()
        }
        
    }
}
