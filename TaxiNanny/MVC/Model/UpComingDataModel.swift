//
//  UpComingDataModel.swift
//  demo
//
//  Created by Shashwat B on 25/07/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UpComingDataModel{
    var driver_name:String = ""
    var amount:String = ""
    var booking_id: String = ""
    var booking_type: String = ""
    var booking_days: String = ""
    var Created_at: String = ""
    var image: String = ""
    
    init() {
        
    }
    
    init(json:JSON) {
        driver_name = json["driver_name"].stringValue
        amount = json["amount"].stringValue
        booking_id = json["booking_id"].stringValue
        booking_type = json["booking_type"].stringValue
        booking_days = json["booking_days"].stringValue
        Created_at = json["Created_at"].stringValue
        image = json["ride_history"]["image"].stringValue
        
    }
}
