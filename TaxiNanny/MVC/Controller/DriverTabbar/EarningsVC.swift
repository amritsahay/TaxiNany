//
//  EarningsVC.swift
//  TaxiNanny
//
//  Created by ip-d on 22/07/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class EarningsVC: ButtonBarPagerTabStripViewController {
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    @IBOutlet weak var collectionview: ButtonBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 18)
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        settings.style.buttonBarItemTitleColor = UIColor.black
        buttonBarView.translatesAutoresizingMaskIntoConstraints = false
        collectionview.backgroundColor = .white
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let todayviewController = storyboard.instantiateViewController(withIdentifier: "TodayViewController") as! TodayViewController
       
        let weeklyviewController = storyboard.instantiateViewController(withIdentifier: "WeeklyViewController") as! WeeklyViewController
        
        return [todayviewController,weeklyviewController]
    }

  
}
