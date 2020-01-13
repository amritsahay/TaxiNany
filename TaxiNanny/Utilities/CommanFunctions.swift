//
//  CommanFunctions.swift
//  TaxiNanny
//
//  Created by Shashwat B on 14/09/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommmanFunction{
    static var riderdetails = [RiderDetailmodel]()
    static var pastdatamodel = [PastDataModel]()
    static var upcomingmodel = [UpComingDataModel]()
    
    static func setriderdetails(data:JSON){
        riderdetails.removeAll()
        for i in data.arrayValue{
            riderdetails.append(RiderDetailmodel(json: i))
        }
    }
    
    static func updatepickup(index:Int,value:String,lat:String,long:String,pick_id:String){
        riderdetails[index].pickuplocation = value
        riderdetails[index].pickuplat = lat
        riderdetails[index].pickuplog = long
        riderdetails[index].rider_pick_location_id = pick_id
    }
    
    static func updateforallpickup(index:Int,value:String,lat:String,long:String,pick_id:String){
        let c = index - 1
        for i in 0...c{
            riderdetails[i].pickuplocation = value
            riderdetails[i].pickuplat = lat
            riderdetails[i].pickuplog = long
            riderdetails[i].rider_pick_location_id = pick_id
        }
    }
    
    static func updatedrop(index:Int,value:String,lat:String,long:String,drop_id:String){
        riderdetails[index].droplocation = value
        riderdetails[index].droplat = lat
        riderdetails[index].droplog = long
        riderdetails[index].rider_drop_location_id = drop_id
    }
    
    static func updateforalldrop(index:Int,value:String,lat:String,long:String,drop_id:String){
        let c = index - 1
        for i in 0...c{
            riderdetails[i].droplocation = value
            riderdetails[i].droplat = lat
            riderdetails[i].droplog = long
            riderdetails[i].rider_drop_location_id = drop_id
        }
    }
    
    static func getriderdetails() -> [RiderDetailmodel]{
        return riderdetails
    }
    
  
    static func setPastdata(past:JSON){
        for arr in past.arrayValue{
            pastdatamodel.append(PastDataModel(json:arr))
        }
    }
    
    static func setUpcomingdata(upcoming:JSON){
        for arr in upcoming.arrayValue{
            upcomingmodel.append(UpComingDataModel(json:arr))
        }
    }
    
    static func getPastData() ->[PastDataModel]{
        return pastdatamodel
    }
    
    static func getUpcomingData() -> [UpComingDataModel]{
        return upcomingmodel
    }
    
    static func calculateDate(date:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yy, h:mm a"
        let date12 = dateFormatter.string(from: date!)
        
        return date12
        
        
    }
}
