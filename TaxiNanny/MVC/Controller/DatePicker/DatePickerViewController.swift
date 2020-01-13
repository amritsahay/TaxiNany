//
//  DatePickerViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 22/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet weak var lbldisplay: UILabel!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var callby: String = ""
    var max:Bool = false
    var min:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if callby == "date"{
            datePicker?.datePickerMode = .date
            lbldisplay.text = "Date Picker"
        }else{
            datePicker?.datePickerMode = .time
            lbldisplay.text = "Time Picker"
        }
        if max{
            let currentdate = Date()
            datePicker?.maximumDate = currentdate
        }
        
        if min{
            let currentdate = Date()
            datePicker?.minimumDate = currentdate
        }
    }
    
    var call:String{
        return callby
    }
    
    var formattedDate:String {
        let formatter = DateFormatter()
        if callby == "date"{
            formatter.dateFormat = "yyyy-MM-dd"
        }else{
            formatter.dateFormat = "h:mm a"
        }
        return formatter.string(from: datePicker.date)
    }
    
  
    @IBAction func done(_ sender: Any) {
        NotificationCenter.default.post(name: .sdate, object: self)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
}

