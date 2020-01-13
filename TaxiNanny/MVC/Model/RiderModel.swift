//
//  RiderModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on May 29, 2019

import Foundation


class RiderModel : NSObject, NSCoding{

    var createdAt : String!
    var dob : String!
    var firstName : String!
    var gender : String!
    var id : Int!
    var lastName : String!
    var needBooster : String!
    var parentId : String!
    var sitFrontSeat : String!
    var updatedAt : String!

    /**
     * Instantiate the instance
     */

    override init() {
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? String
        dob = dictionary["dob"] as? String
        firstName = dictionary["first_name"] as? String
        gender = dictionary["gender"] as? String
        id = dictionary["id"] as? Int
        lastName = dictionary["last_name"] as? String
        needBooster = dictionary["need_booster"] as? String
        parentId = dictionary["parent_id"] as? String
        sitFrontSeat = dictionary["sit_front_seat"] as? String
        updatedAt = dictionary["updated_at"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if dob != nil{
            dictionary["dob"] = dob
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if needBooster != nil{
            dictionary["need_booster"] = needBooster
        }
        if parentId != nil{
            dictionary["parent_id"] = parentId
        }
        if sitFrontSeat != nil{
            dictionary["sit_front_seat"] = sitFrontSeat
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        dob = aDecoder.decodeObject(forKey: "dob") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        needBooster = aDecoder.decodeObject(forKey: "need_booster") as? String
        parentId = aDecoder.decodeObject(forKey: "parent_id") as? String
        sitFrontSeat = aDecoder.decodeObject(forKey: "sit_front_seat") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if dob != nil{
            aCoder.encode(dob, forKey: "dob")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if needBooster != nil{
            aCoder.encode(needBooster, forKey: "need_booster")
        }
        if parentId != nil{
            aCoder.encode(parentId, forKey: "parent_id")
        }
        if sitFrontSeat != nil{
            aCoder.encode(sitFrontSeat, forKey: "sit_front_seat")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
    }
}
