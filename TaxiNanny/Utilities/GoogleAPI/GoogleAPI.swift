//
//  GoogleAPI.swift
//  TaxiNanny
//
//  Created by ip-d on 13/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol GoogleAPIDelegate {
    func didAutoCompleteFinished(addresses:[JSON]?)
    func didAutoCompleteFailed(error:String?)
    func didPlaceDetailFinished(place:[String:JSON]?)
    
}

class GoogleAPI: NSObject {
    
    static let shared:GoogleAPI = GoogleAPI()
    
    var delegate: GoogleAPIDelegate?
    //AIzaSyAK5It4p1CiJ2gFzWRbfs24Cibo2QTcPRU
    //AIzaSyCxj7Z3cWeV8phaVuua1cSQ88bWT_ls5u0
    let api_key = "AIzaSyAK5It4p1CiJ2gFzWRbfs24Cibo2QTcPRU"
    
    func autoComplete(keyword:String,session:String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Utility.shared.startProgress(message:"Please wait.")
        
        let parameter:Parameters = ["input":keyword,"key":api_key,"sessiontoken":session]
        
        let headers:HTTPHeaders? = nil
        
        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        
        Alamofire.request(url, method: .get, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                
                Utility.shared.stopProgress()
                print("Validation Successful")
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "OK"
                    {
                        let results = dictionary?["predictions"]?.arrayValue
                        self.delegate?.didAutoCompleteFinished(addresses:results)
                        
                    }
                    else
                    {
                        let error_message = dictionary?["error_message"]?.string
                        self.delegate?.didAutoCompleteFailed(error:error_message)
                    }
                }
                
            case .failure(let error):
                Utility.shared.stopProgress()
                self.delegate?.didAutoCompleteFailed(error:error.localizedDescription)
            }
        }
    }
    
    func placeDetail(placeID:String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let parameter:Parameters = ["placeid":placeID,"key":api_key]
        let headers:HTTPHeaders? = nil
        let url = "https://maps.googleapis.com/maps/api/place/details/json"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .get, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                
                Utility.shared.stopProgress()
                print("Validation Successful")
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "OK"
                    {
                        let results = dictionary?["result"]?.dictionary
                         self.delegate?.didPlaceDetailFinished(place: results)
                        
                        print(results)
                        //test
                        
                    }
                    else
                    {
                        
                    }
                }
                
            case .failure(let error):
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
        }
    }
    
   
    
}
