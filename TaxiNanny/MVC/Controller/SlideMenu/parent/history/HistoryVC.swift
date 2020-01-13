//
//  HistoryVC.swift
//  TaxiNanny
//
//  Created by ip-d on 21/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import XLPagerTabStrip



class HistoryVC: ButtonBarPagerTabStripViewController {
   
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    @IBOutlet weak var collectionview: ButtonBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 18)
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = .orange
        
        settings.style.buttonBarItemTitleColor = UIColor.white
        buttonBarView.translatesAutoresizingMaskIntoConstraints = false
       // collectionview.backgroundColor = .white
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let pastviewController = storyboard.instantiateViewController(withIdentifier: "PastViewController") as! PastViewController
        
        let upcomimgviewController = storyboard.instantiateViewController(withIdentifier: "UpCommingViewController") as! UpCommingViewController
        
        return [pastviewController,upcomimgviewController]
    }
   

    //Mark - Button method
    
    @IBAction func menu(_ sender: Any) {
        AppDelegate.shared.openDrawer()
    }
    
    @IBAction func close(_ sender: Any) {
      dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upcoming(_ sender: Any) {
        Utility.shared.showSnackBarMessage(message:"under construction!!")
    }
    
}



