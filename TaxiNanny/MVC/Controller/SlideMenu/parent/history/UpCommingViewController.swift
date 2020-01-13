//
//  UpCommingViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 15/10/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class UpCommingViewController: UIViewController,IndicatorInfoProvider {

    @IBOutlet weak var list_view: UITableView!
     var upcommingdata = CommmanFunction.getUpcomingData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list_view.register(UINib(nibName:"HistoryCell", bundle:nil), forCellReuseIdentifier:"HistoryCell")
        self.list_view.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Upcomming")
    }
}

extension UpCommingViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcommingdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"HistoryCell", for: indexPath) as! HistoryCell
        cell.upcomingData = upcommingdata[indexPath.row]
        return cell
    }
    
}
