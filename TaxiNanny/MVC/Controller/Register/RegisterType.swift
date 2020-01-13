//
//  RegisterType.swift
//  TaxiNanny
//
//  Created by ip-d on 17/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class RegisterType: UIViewController {
    
    @IBOutlet weak var driver_view: BorderView!
    @IBOutlet weak var parent_view: BorderView!
    var isParent:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        parent()
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func driver_button(_ sender: Any) {
        drive()
    }
    
    @IBAction func parent_button(_ sender: Any) {
        parent()
    }
    
    @IBAction func next(_ sender: Any) {
        if isParent{
            let _registerForm = self.storyboard?.instantiateViewController(withIdentifier:"RegisterForm") as! RegisterForm
            _registerForm.isParent = isParent
            self.navigationController?.pushViewController(_registerForm, animated:true)
        }else{
            let _registerForm = self.storyboard?.instantiateViewController(withIdentifier:"DriverRegisterForm") as! DriverRegisterForm
            _registerForm.isParent = isParent
            self.navigationController?.pushViewController(_registerForm, animated:true)

        }
    }
    
    func parent()
    {
        driver_view.layer.borderWidth = 0
        parent_view.layer.borderWidth = 2
        isParent = true
    }
    
    func drive()
    {
        driver_view.layer.borderWidth = 2
        parent_view.layer.borderWidth = 0
        isParent = false
    }
    
}
