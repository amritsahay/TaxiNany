//
//  TodayViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 27/08/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TodayViewController: UIViewController,IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Today")
    }
}
