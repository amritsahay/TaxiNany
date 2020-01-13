//
//  DataFunction.swift
//  TaxiNanny
//
//  Created by Shashwat B on 15/08/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//
//
import Foundation
import SwiftyJSON
import UIKit

class UserData{
    static var userdatamodel = [UserDetailmodel]()


    static func setUserdata(data:JSON){
        userdatamodel.append(UserDetailmodel(json:data))
    }

    static func getUserData() ->[UserDetailmodel]{
        return userdatamodel
    }
}

