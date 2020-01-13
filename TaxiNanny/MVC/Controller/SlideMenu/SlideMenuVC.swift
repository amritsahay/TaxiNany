//
//  SlideMenuVC.swift
//  Luggage
//
//  Created by esferasoft on 15/04/19.
//  Copyright © 2019 esferasoft. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire
import SwiftyJSON
import SDWebImage

class SlideMenuVC: UIViewController {
    
    @IBOutlet weak var tableViewSlideMenu: UITableView!
    @IBOutlet weak var userimgView: UIImageView!
    var userdata = [UserDetailmodel]()
    @IBOutlet weak var titleName: UILabel!
    
    
    var titles = NSMutableArray()
    var imgNames = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        titles = ["Home","Payment","History","Notification","Settings","Help","Logout"]
        
        imgNames = ["Home","Payment","History-active",            "Notifications","Settings","Help","Logout"]
        
        setUI()
        
    }
    
    func setUI(){
        
        tableViewSlideMenu.register(UINib(nibName: "SlideMenuCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableViewSlideMenu.estimatedRowHeight = 100
        // self.tableViewSlideMenu.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userdata = UserData.getUserData()
        let name = userdata[0].first_name + " " + userdata[0].last_name
        titleName.text = name
        let p_url = URL(string: userdata[0].image)
        userimgView.sd_setImage(with: p_url, completed: nil)
        // lblName.text = UserDefaults.standard.value(forKey:"name") as? String
    }
    
    //Mark - Button method
    
    @IBAction func editProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.present(vc, animated: true, completion: nil)
        
        // let vc = self.storyboard?.instantiateViewController(withIdentifier:"EditProfileVC")
        // pushViewController(viewController: vc!)
    }
    
    func pushViewController(viewController:UIViewController)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let navController = UINavigationController.init(rootViewController:viewController)
        navController.navigationBar.isHidden = true
        appDelegate.drawerController?.mainViewController = navController
        appDelegate.drawerController?.setDrawerState(.closed, animated: true)
    }
    
    //
    
}

//MARK:- TableView Delegates and DataSource
extension SlideMenuVC:UITableViewDelegate,UITableViewDataSource
{
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 59
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellObj:SlideMenuCell! = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as? SlideMenuCell
        
        if cellObj == nil
        {
            let nibArray:NSArray = Bundle.main.loadNibNamed("SlideMenuCell", owner: nil, options: nil )! as NSArray
            cellObj = nibArray.object(at: 0) as? SlideMenuCell
        }
        //cellObj.selectionStyle = UITableViewCell.SelectionStyle.none
        cellObj.lblTitle?.text = titles.object(at:indexPath.row) as? String
        let nameStr =  imgNames.object(at:indexPath.row) as? String
        let yourImage: UIImage = UIImage(named: nameStr!)!
        cellObj.imgView.image = yourImage
        cellObj.imgView.image = cellObj.imgView.image?.withRenderingMode(.alwaysTemplate)
        cellObj.imgView.tintColor = UIColor.darkGray
        
        return cellObj
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        switch indexPath.row {
        case 0:
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"ParentHomeVC")
            pushViewController(viewController: vc!)
            break;
        case 1:
            //payment
             let vc = self.storyboard?.instantiateViewController(withIdentifier:"PaymentViewController") as! PaymentViewController
            // pre(viewController: vc!)
             vc.delete = true
             vc.btnhide = true
             present(vc, animated: true, completion: nil)
           // Utility.shared.showSnackBarMessage(message:"under construction!!")
            break;
            
        case 2:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let token1 =  UserDefaults.standard.value(forKey:"token") as? String
            let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
            var finalToken = ""
            
            if let _ = token1, !token1!.isEmpty {
                /* string is not blank */
                finalToken = "Bearer "+token1!
            }
            
           
            
            let headers = ["Authorization":finalToken]
            let url =  Constant.Baseurl + "ridehistoryparent"
            Utility.shared.startProgress(message:"Please wait.")
                
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in UIApplication.shared.isNetworkActivityIndicatorVisible = false
                Utility.shared.stopProgress()
                    switch response.result {
                    case .success:
                        
                        let resJson = JSON(response.result.value!)
                        print(resJson)
                        if resJson["status"].stringValue == "true"{
                            let pastdata = resJson["data"]["Previous"]
                            let upcoming = resJson["data"]["Upcoming"]
                            CommmanFunction.setPastdata(past: pastdata)
                            CommmanFunction.setUpcomingdata(upcoming:upcoming)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"HistoryVC")
                            self.present(vc!, animated:true, completion: nil)
                        }
                        
                    case .failure(let _):
                        self.dismiss(animated: true, completion: nil)
                        break
                        
                    }
                    
                }
            
       
            break;
            
        case 3:
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"NotificationVC")
            pushViewController(viewController: vc!)
            break;
            
        case 4:

            let vc = self.storyboard?.instantiateViewController(withIdentifier:"SettingVC")
            self.present(vc!, animated:true, completion: nil)
            break;
            
        case 5:
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"HelpVC")
            pushViewController(viewController: vc!)
            //Utility.shared.showSnackBarMessage(message:"under construction!!")
            
            break;
            
        case 6:
            //Logout
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewcontrol:LogoutPopupViewController = storyboard.instantiateViewController(withIdentifier: "LogoutPopupViewController") as! LogoutPopupViewController
            self.present(viewcontrol, animated: true, completion: nil)
            // Utility.shared.showSnackBarMessage(message:"under construction!!")
            
            break;
            
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}

// webseevice
