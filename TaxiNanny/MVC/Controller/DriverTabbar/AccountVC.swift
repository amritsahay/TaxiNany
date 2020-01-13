//
//  AccountVC.swift
//  TaxiNanny
//
//  Created by ip-d on 22/07/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccountVC: UIViewController {

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    var titles = NSMutableArray()
    var imgNames = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileimg.layer.cornerRadius = profileimg.frame.size.width / 2
        profileimg.clipsToBounds = true
        titles = ["Way Bill","Documents","Settings","Ratings","About","Help","Logout"]
        
        imgNames = ["note","Payment","History-active",            "Notifications","Settings","Help","Logout"]
        
        setUI()
    }
    func setUI(){
        
        tableview.register(UINib(nibName: "SlideMenuCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableview.estimatedRowHeight = 100
        // self.tableViewSlideMenu.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    func pushViewController(viewController:UIViewController)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let navController = UINavigationController.init(rootViewController:viewController)
        navController.navigationBar.isHidden = true
        appDelegate.drawerController?.mainViewController = navController
        appDelegate.drawerController?.setDrawerState(.closed, animated: true)
    }
    @IBAction func editcar(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"EditCarDetailsViewController") as! EditCarDetailsViewController
        self.present(vc, animated: true, completion: nil)
    }
}
extension AccountVC:UITableViewDelegate,UITableViewDataSource
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
            
            
            
            break;
        case 1:
            //payment
           // let vc = self.storyboard?.instantiateViewController(withIdentifier:"ReviewYourTripVC")
           // pushViewController(viewController: vc!)
            
            // Utility.shared.showSnackBarMessage(message:"under construction!!")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
            self.present(vc, animated: true, completion: nil)
            break;
            
        case 2:
            
           // let vc = self.storyboard?.instantiateViewController(withIdentifier:"HistoryVC")
          //  pushViewController(viewController: vc!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            self.present(vc, animated: true, completion: nil)
            break;
            
        case 3:
            
            //let vc = self.storyboard?.instantiateViewController(withIdentifier:"NotificationVC")
           // pushViewController(viewController: vc!)
            break;
            
        case 4:
            
           // let vc = self.storyboard?.instantiateViewController(withIdentifier:"SettingVC")
            //pushViewController(viewController: vc!)
            break;
            
        case 5:
            
            //let vc = self.storyboard?.instantiateViewController(withIdentifier:"HelpVC")
           // pushViewController(viewController: vc!)
            //Utility.shared.showSnackBarMessage(message:"under construction!!")
            
            break;
            
        case 6:
            //Logout
            logoutApi()
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
extension AccountVC
{
    func logoutApi() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        
        let parameter:Parameters = [:]
        
        let headers:HTTPHeaders? = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "logout"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
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
                        Constant.writeStringUserPreference(Constant.IsAutoLoginEnableKey, value: "\(0)")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"FirstViewController")
                        self.pushViewController(viewController: vc!)
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
