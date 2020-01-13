//
//  VerifyMobileVC.swift
//  TaxiNanny
//
//  Created by ip-d on 19/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class VerifyMobileVC: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var otp: UITextField!
    var isParent:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // Mark :- Button Method
    
    @IBAction func changeNumber(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func resendCode(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
    @IBAction func verify(_ sender: Any) {
        if (otp.text?.isBlank)!
        {
            Utility.shared.showSnackBarMessage(message:"Please enter the otp code.")
        }
        else
        {
            if isParent == true
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier:"ParentHomeVC") as! ParentHomeVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier:"SelectVehicleTypeVC") as! SelectVehicleTypeVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
}

extension VerifyMobileVC
{
    func setUI()
    {
        
    }
}
