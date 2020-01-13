//
//  TabbarVC.swift
//  TaxiNanny
//
//  Created by ip-d on 22/07/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class TabbarVC: UIViewController {
    

    @IBOutlet weak var containerView: UIView!
   
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var switchOnOff: UISwitch!
    @IBOutlet weak var lblswitch: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "DriverHomeVC")
        addChild(controller)
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.buttomView.isHidden = false
    }
    

    //Mark - Button method
    @IBAction func home(_ sender: Any) {
        //Utility.shared.showSnackBarMessage(message:"under construction!!")
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "DriverHomeVC")
        addChild(controller)
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.buttomView.isHidden = false
        
    }
    
    @IBAction func earnings(_ sender: Any) {
        //Utility.shared.showSnackBarMessage(message:"under construction!!")
        //SocketLayer.shared.updateStatus(Status: 2)
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "EarningsVC")
        addChild(controller)
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.buttomView.isHidden = true
        
    }
    
    @IBAction func rating(_ sender: Any) {
        //Utility.shared.showSnackBarMessage(message:"under construction!!")
        // SocketLayer.shared.sendMessage(message: "Hello esfera")
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "RatingVC")
        addChild(controller)
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.buttomView.isHidden = true
    }
    
    @IBAction func account(_ sender: Any) {
        //Utility.shared.showSnackBarMessage(message:"under construction!!")
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "AccountVC")
        addChild(controller)
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.buttomView.isHidden = true
        
        //  let vc = self.storyboard?.instantiateViewController(withIdentifier:"PickupRequestVC")
        //  vc!.modalPresentationStyle = .overCurrentContext
        //  vc!.modalTransitionStyle = .crossDissolve
        //  self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func `switch`(_ sender: Any) {
        //        Save driver online/offline status
        
        if switchOnOff.isOn {
            print("ON")
            lblswitch.text = "ONLINE"
           // updateDriverStatusApi(status: 1)
        }
        else {
            print ("OFF")
            lblswitch.text = "OFFLINE"
           // updateDriverStatusApi(status: 0)
        }
    }
    

}
