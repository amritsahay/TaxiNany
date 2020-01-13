//
//  FavouriteLocationList.swift
//  TaxiNanny
//
//  Created by Shashwat B on 13/09/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import Foundation
import SwiftyJSON


struct FavouriteLocationListModel {
    var created_at:String = ""
    var description:String = ""
    var id: String = ""
    var parent_id: String = ""
    var rider_id: String = ""
    var location_type: String = ""
    var location_name: String = ""
    var longitude: String = ""
    var lattitude: String = ""
    var updated_at: String = ""
    var nick_name: String = ""
    
    init() {
        
    }
    
    init(json:JSON) {
        created_at =  json["created_at"].stringValue
        description =  json["description"].stringValue
        id =  json["id"].stringValue
        parent_id =  json["parent_id"].stringValue
        rider_id =  json["rider_id"].stringValue
        location_type =  json["location_type"].stringValue
        location_name =  json["location_name"].stringValue
        longitude =  json["longitude"].stringValue
        lattitude =  json["lattitude"].stringValue
        updated_at =  json["updated_at"].stringValue
        nick_name =  json["nick_name"].stringValue
    }
}
