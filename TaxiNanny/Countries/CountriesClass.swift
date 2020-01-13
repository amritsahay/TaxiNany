//
//  CountriesClass.swift
//  TaxiNanny
//
//  Created by ip-d on 31/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class CountriesClass: NSObject {
    
    static let shared:CountriesClass = CountriesClass()
    var list:Array<Dictionary<String, Any>>? = nil
    
    override init() {
        super.init()
        list = self.getCountries()
    }
    
    func getCountries() -> Array<Dictionary<String, Any>>?
    {
        if let path = Bundle.main.path(forResource: "countries_states_cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Array<Dictionary<String, Any>>
                {
                    return jsonResult
                }
            } catch {
                Utility.shared.showSnackBarMessage(message:"Something went wrong!!")
            }
        }
        return nil
    }
    
}
