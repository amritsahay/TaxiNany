//
//  RiderDetailsModel.swift
//  TaxiNanny
//
//  Created by Shashwat B on 14/09/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RiderDetailmodel {
    var created_at: String = ""
    var dob: String = ""
    var image:String = ""
    var gender:String = ""
    var id:String = ""
    var first_name:String = ""
    var parent_id:String = ""
    var updated_at:String = ""
    var need_booster:String = ""
    var last_name:String = ""
    var sit_front_seat:String = ""
    var pickuplocation:String = ""
    var droplocation: String = ""
    var pickuplat:String = ""
    var pickuplog:String = ""
    var droplat:String = ""
    var droplog:String = ""
    var rider_drop_location_id:String = ""
    var rider_pick_location_id:String = ""
    var drop_off_instruction:String = ""
    var pick_up_instruction:String = ""
    var kids_sign_up:String = ""
    var kids_sign_in:String = ""
    var priority_drop:String = ""
    var priority_pick:String = ""
    
    init() {
        
    }
    
    init(json:JSON) {
          created_at = json["created_at"].stringValue
          dob = json["dob"].stringValue
          image = json["image"].stringValue
          gender = json["gender"].stringValue
          id = json["id"].stringValue
          first_name = json["first_name"].stringValue
          parent_id = json["parent_id"].stringValue
          updated_at = json["updated_at"].stringValue
          need_booster = json["need_booster"].stringValue
          last_name = json["last_name"].stringValue
          sit_front_seat = json["sit_front_seat"].stringValue
          pickuplocation = json["pickuplocation"].stringValue
          droplocation = json["droplocation"].stringValue
          pickuplat = json["pickuplat"].stringValue
          pickuplog = json["pickuplog"].stringValue
          droplat = json["droplat"].stringValue
          droplog = json["droplog"].stringValue
    }
}
