//
//  Constant.swift
//  TaxiNanny
//
//  Created by ip-d on 24/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class Constant: NSObject {
    
    ///track
    static let deletetoken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjA0ZDBjNGU4NDdiYTZiYzYxMjk2YWJkZTFmMTAyMzZhM2IzNGJhYzVlMGJmMmUyMWQ1NTQ1MzA4ZTg0YWFmZDA3MWZkN2RjMGVmYTU4YWY1In0.eyJhdWQiOiIyIiwianRpIjoiMDRkMGM0ZTg0N2JhNmJjNjEyOTZhYmRlMWYxMDIzNmEzYjM0YmFjNWUwYmYyZTIxZDU1NDUzMDhlODRhYWZkMDcxZmQ3ZGMwZWZhNThhZjUiLCJpYXQiOjE1NjMyNzIzMzEsIm5iZiI6MTU2MzI3MjMzMSwiZXhwIjoxNTk0ODk0NzMxLCJzdWIiOiI3MyIsInNjb3BlcyI6W119.hQ14-bOIAChcDm_l6eU8OT24Ny7b694y828QBW7AJK0Z6i0JCr4VtqdhMYHTzeWVAiKk-FOwCBN3xQj4dCyqZvKMIBz1F4U-hyTgKf32V0GOth5CkEFxCK5G_hshiScFa19ZWNg0uiLtlqtX0qi__negus57273eefdd-wSd6OVZdyRccGPIT_SXzcg03-0yeuZ4op6rQqGlPVe-sDpRQrSz39RkKn_sQcuKqK4sjasMQz_M-UqR8QB4Qo0tHRlRGtw-aIyw-sBCPAyx-X7FbjW1VdB0wxu8bBWuUuxIs0BRA52Jl-VtmAHl7kykGShzzHwVkku1q-j2MCDBkDHthia1Bx_iTp4nsbx8FaYw7-5OCMjhU9yeLPth0yGhMVhfKqgeubxEQuKorz4SyouhSFd_0CY9XxZ_dpwwITyyQtc5mm47vYawiENn0vcihsPu2bsyDH45yfV1sACZu-ETa_fL0VEPSWANHUBEi6uUtITofBhW5si8w3VV-O0glegLC7meXxL-hvdPGwVutGBWWfGLFWmmC1YkJWWoa46uTfU1SHAX8ZKclh9AevYPrPLK7uSohW9rl2w6gH_3m8q3xufniwyBvq2-PXDOls2L7pG7UuDyMpfUXlSLWOp7UjXEHL686NfzWi1Z5hZ9OOdl8MmFKDmBEikAyYMjIZhjbU8"
    static let Baseurl = "http://178.128.116.149/taxinanny1/public/api/"
    static let ImagesUrl = "http://178.128.116.149/taxinanny1/public/"
    static let Socket_StreamURL = "http://178.128.116.149:9002/track"
    static let tourtitle1 = "Welcome"
     static let tourtitle2 = "Customizable Rides"
     static let tourtitle3 = "Certified TaxiNannies"
     static let tourtitle4 = "Get Real-Time Updates"
    static let tourtext1 = "It takes a village to raise a child. Finding somebody reliable and trustworthy to transport your children to-and-from school, activities, etc. is quit a daunting task. Taxinanny is a full service transportation company that is licensed & insured to transport children."
    static let tourtext2 = "Customize rides for all your transportation needs. Schedule Recurring Rides and add up to 4 rides per ride, providing you with discounts for addtional rides. Schedule rides at level 24 hours in advance to ensure availability."
    static let tourtext3 = "Get matched with a Certified TaxiNanny, an experienced Caregiver designated for the transportation of children, giving you the peace of mind that your loved ones are in good hands."
    static let tourtext4 = "Receive alerts for when your child is picked-up and dropped-off. Monitor rides in real time and know exactly where your child is at all times during the ride."
    
    // http://159.65.145.230:9002/track
    // http://159.65.145.230:9002/
    // http://165.22.215.99:9002/
    
    static let IsAutoLoginEnableKey =  "IsAutoLoginEnable"

    //user default
    static func writeStringUserPreference(_ key: String?, value: Any?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key ?? "")
        userDefaults.synchronize()
    }
    
    // ** Read
    
    static func readStringUserPreference(_ key: String?) -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: key!) as? String
    }
    
    func headerColor() -> UIColor? {
        return convertHexToUIColor(pHexString:"#9EC138")
    }
    
    /////
    
    func convertHexToUIColor(pHexString: String) -> UIColor? {
        
        if pHexString.hasPrefix("#") {
            let _Start = pHexString.index(pHexString.startIndex, offsetBy: 1) // character index next to '#'
            let _HexColor = String(pHexString[_Start...]) // remove '#'
            
            if _HexColor.count == 6 {
                let _Scanner = Scanner(string: _HexColor)
                var _HexNumber: UInt32 = 0
                
                if _Scanner.scanHexInt32(&_HexNumber) {
                    let _Red = CGFloat((_HexNumber & 0xff0000) >> 16) / 255
                    let _Green = CGFloat((_HexNumber & 0x00ff00) >> 8) / 255
                    let _Blue = CGFloat(_HexNumber & 0x0000ff) / 255
                    
                    return UIColor(red: _Red, green: _Green, blue: _Blue, alpha: 1)
                }
            }
        }
        
        return nil
    }
}
