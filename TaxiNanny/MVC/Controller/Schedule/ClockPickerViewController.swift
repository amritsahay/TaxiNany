//
//  ClockPickerViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 15/10/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import AMClockView

class ClockPickerViewController: UIViewController, AMClockViewDelegate {

    @IBOutlet weak var lblshowtime: UILabel!
    @IBOutlet weak var clockView: AMClockView!
    override func viewDidLoad() {
        super.viewDidLoad()
        clockView.delegate = self
      
    }
    
    func clockView(_ clockView: AMClockView, didChangeDate date: Date) {
        print(date)
    }
    
    @IBAction func ok(_ sender: Any) {
    }
    

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
