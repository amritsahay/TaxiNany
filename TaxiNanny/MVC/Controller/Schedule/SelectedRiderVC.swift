//
//  SelectedRiderVC.swift
//  TaxiNanny
//
//  Created by ip-d on 07/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage


class SelectedRiderVC: UIViewController {
    
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var list_view: UITableView!
    
    @IBOutlet weak var lbldate: UILabel!
    var riderlist:[JSON] = []
    var checkPopup:Bool = true
    var riderlistmodel = [RiderDetailmodel]()
    var alertpickup:String = "pick"
    var var_date:String = ""
    var var_time:String = ""
    var pickup:Int = 0
    var drop:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopup), name: .sdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        riderlistmodel.removeAll()
        riderlistmodel = CommmanFunction.getriderdetails()
        list_view.reloadData()
        if riderlist.count > 1{
            if self.alertpickup == "pick"{
                alertpopup(msg: "Will all selected rider be picked-up from the same location?")
            }else if self.alertpickup == "drop"{
                alertpopup(msg: "Will all selected rider be drop from the same location?")
            }
        }
    }
    
    @objc func handlePopup(notification: Notification){
        let datavc = notification.object as! DatePickerViewController
        let callby = datavc.call
        let date = datavc.formattedDate
        if callby == "date"{
            lbldate.text = date
            self.var_date = date
        }else if callby == "time"{
            lbltime.text = date
            self.var_time = date
        }
       
    }
    
    func setUI()
    {
        list_view.register(UINib(nibName:"selectedRiderCell", bundle:nil), forCellReuseIdentifier:"selectedRiderCell")
        self.list_view.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    func alertpopup(msg:String)  {
        
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                //Yes
                if self.alertpickup == "pick"{
                    self.alertpickup = "drop"
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickupLocation") as! PickupLocation
                    vc.riderlist = self.riderlist
                    vc.riderid = self.riderlist[0]["id"].intValue
                    vc.setforall = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if self.alertpickup == "drop"{
                    self.alertpickup = ""
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DropLocation") as! DropLocation
                    vc.riderlist = self.riderlist
                    vc.riderid = self.riderlist[0]["id"].intValue
                    vc.setforall = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            case .cancel:
                print("cancel")
                
                //no
                
            case .destructive:
                print("destructive")
                
            }}))
        
        let cancel = UIAlertAction(title: "NO", style: .default, handler: { action in
            self.alertpickup = ""
            self.list_view.reloadData()
        })
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func datepicker(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        vc.callby = "date"
        vc.min = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func timepicker(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        vc.callby = "time"
        self.present(vc, animated: true, completion: nil)
    }
    // Marks - Button Method
    
    @IBAction func back(_ sender: Any) {
        // self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        if self.var_date == ""{
            Utility.shared.showSnackBarMessage(message: "Please choose date for booking")
            return
        }
        if self.var_time == ""{
            Utility.shared.showSnackBarMessage(message: "Please choose time for booking")
            return
        }
        if self.pickup < riderlistmodel.count{
            Utility.shared.showSnackBarMessage(message: "Please Enter Pickup Location")
            return
        }
        if self.drop < riderlistmodel.count{
            Utility.shared.showSnackBarMessage(message: "Please Enter Drop Location")
            return
        }
        let alert = UIAlertController(title: "Alert", message: "Is this a Recurring ride?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                //Yes
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Listofday") as! Listofday
                vc.vardate = self.var_date
                vc.vartime = self.var_time
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .cancel:
                print("cancel")
                
                //no
                
            case .destructive:
                print("destructive")
                
            }}))
        
        let cancel = UIAlertAction(title: "NO", style: .default, handler: { action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Pickup_and_droupoffVC") as! Pickup_and_droupoffVC
            vc.vardate = self.var_date
            vc.vartime = self.var_time
            self.navigationController?.pushViewController(vc, animated: true)
          //  self.list_view.reloadData()
        })
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }

    //imageView
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

extension SelectedRiderVC:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riderlistmodel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"selectedRiderCell", for: indexPath) as! selectedRiderCell
        
        //let jsonObj = riderlist[indexPath.row]
        
        //
      //  let first = jsonObj["first_name"].stringValue
     //   let last =  jsonObj["last_name"].stringValue
     //   let name =  first+" "+last
      //  cell.name.text = name
        cell.name.text = riderlistmodel[indexPath.row].first_name + " " + riderlistmodel[indexPath.row].last_name
        //
       // cell.name.text = jsonObj["first_name"].stringValue
        let imgPath = riderlistmodel[indexPath.row].image //jsonObj["image"].stringValue
        
        if !imgPath.isEmpty {
            //let imgUrlStr = imgUrl+"/"+imgPath!
            loadImageWith(imgView: cell.imgView, url: imgPath)
        }
        cell.Pickup.tag = indexPath.row
        cell.DropLocation.tag = indexPath.row
        let drop = riderlistmodel[indexPath.row].droplocation
        if drop == ""{
            cell.dropLabel.text = "Enter pickup location"
        }else{
            cell.dropLabel.text = drop
            self.drop += 1
        }
        let pickup = riderlistmodel[indexPath.row].pickuplocation
        if pickup == ""{
            cell.pickupLabel.text = "Enter pickup location"
        }else{
            cell.pickupLabel.text = pickup
            self.pickup += 1
        }
        
        cell.Pickup.addTarget(self, action: #selector(self.pickup(_:)), for: .touchUpInside)
        cell.DropLocation.addTarget(self, action: #selector(self.dropLocation(_:)), for: .touchUpInside)
        cell.celldeligate = self
        cell.index = indexPath
        return cell
    }
    
    
    @objc func pickup(_ sender: UIButton?) {
        
        let jsonObj = riderlist[(sender?.tag)!]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickupLocation") as! PickupLocation
        vc.riderid =  jsonObj["id"].int
        vc.riderlist = riderlist
        vc.indexpick = sender!.tag
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
   
    
    @objc func dropLocation(_ sender: UIButton?) {
        let jsonObj = riderlist[(sender?.tag)!]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DropLocation") as! DropLocation
        vc.riderid =  jsonObj["id"].int
        vc.riderlist = riderlist
        vc.indexdrop = sender!.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SelectedRiderVC:UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickupLocation") as! PickupLocation
        //        self.navigationController?.pushViewController(vc, animated: true)
       
    }
}
extension SelectedRiderVC: RiderTableViewButton{
    func OnClick(index: Int) {
        print(index)
    }
    
}
