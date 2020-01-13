//
//  HistoryCell.swift
//  TaxiNanny
//
//  Created by ip-d on 21/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import GoogleMaps

class HistoryCell: UITableViewCell {
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var vehicleType: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var payment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    var pastData:PastDataModel?{
        didSet{
            
            let d = pastData?.Created_at
            
            dateTime.text = CommmanFunction.calculateDate(date: d!)
            let am = pastData?.amount
            
            if(am != ""){
                amount.text = am! + " $"
            }else{
                amount.text = "NA"
            }
            
          vehicleType.text = pastData?.driver_name
         
            
        }
    }
    
    var upcomingData:UpComingDataModel?{
        didSet{
            
            let d = upcomingData?.Created_at
            
            dateTime.text = CommmanFunction.calculateDate(date: d!)
            let am = upcomingData?.amount
            
            if(am != nil){
                amount.text = am! + " $"
            }else{
                amount.text = "NA"
            }
           vehicleType.text = upcomingData?.driver_name
        }
    }
}
