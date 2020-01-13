//
//  DriverWebViewViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 20/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit

class DriverWebViewViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    var urlS:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlS!)
        let requestObj = URLRequest(url: url!)
        webview.loadRequest(requestObj)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
}
