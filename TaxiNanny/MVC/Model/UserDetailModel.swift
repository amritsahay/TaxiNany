//
//  UserDetailModel.swift
//  TaxiNanny
//
//  Created by Shashwat B on 15/08/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import Foundation
import SwiftyJSON


struct UserDetailmodel {
    var image: String = ""
    var first_name: String = ""
    var last_name:String = ""
    init() {
        
    }
    
    init(json:JSON) {
        image = json["user_details_parent"]["image"].stringValue
        first_name = json["user_details_parent"]["first_name"].stringValue
        last_name = json["user_details_parent"]["last_name"].stringValue
    }
}
