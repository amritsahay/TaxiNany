//
//  PastViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 15/10/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import XLPagerTabStrip


class PastViewController: UIViewController,IndicatorInfoProvider {
    var historylist:[JSON] = []
    var pastdata = CommmanFunction.getPastData()
    @IBOutlet weak var list_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         list_view.register(UINib(nibName:"HistoryCell", bundle:nil), forCellReuseIdentifier:"HistoryCell")
         self.list_view.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Past")
    }
    

}


extension PastViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"HistoryCell", for: indexPath) as! HistoryCell
        cell.pastData = pastdata[indexPath.row]
        return cell
    }
    
}
