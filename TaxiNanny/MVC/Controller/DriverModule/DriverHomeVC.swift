//
//  DriverHomeVC.swift
//  TaxiNanny
//
//  Created by ip-d on 14/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import GoogleMaps

class DriverHomeVC: UIViewController {

    @IBOutlet weak var totalearned: UILabel!
    @IBOutlet weak var totalhours: UILabel!
    @IBOutlet weak var totaltrip: UILabel!
    @IBOutlet weak var switchOnOff: UISwitch!
    @IBOutlet weak var lblswitch: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var lbltitle: UILabel!
    private let locationManager = CLLocationManager()
    private let searchRadius: Double = 1000
    
    private var lat: Double! = nil
    private var lng: Double! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 18)
        //self.mapView.addSubview(cardView)
        //self.mapView.addSubview(lbltitle)
        self.view.addSubview(mapView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          // updateDriverLocationApi()
        
           addNotification()
        //14, 525 , 106 Damru wala hanshraj raguwanshi
         SocketLayer.shared.connect("/110")
        
         if SocketLayer.shared.status()
         {
            print(SocketLayer.shared.status())
//            let parameters:NSDictionary = ["lat": 30.7046,"lng": 76.7179,"bearing": 1,"accuracy": 2,
//                                           "speed": 60,"altitude": 1]
//
//            SocketLayer.shared.updateLocation(parameter:parameters)
         }
         else
         {
            //SocketLayer.shared.reConnect()
         }
        
         var scheduleTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(DriverHomeVC.scheduleTime), userInfo: nil, repeats: false)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       // removeNotification()
    }
    
    @objc func scheduleTime()
    {
        NSLog("schedule")
        
        let parameters:NSDictionary = ["lat": 30.7046,"lng": 76.7179,"bearing": 1,"accuracy": 2,
                                       "speed": 60,"altitude": 1]
        
        SocketLayer.shared.updateLocation(parameter:parameters)
    }
    
    //Mark - Button method

    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        //
        let camera = GMSCameraPosition(target:coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        //creating a marker on the map
        let marker = GMSMarker()
        
        if (lat != nil) {
           marker.position = CLLocationCoordinate2D(latitude:lat, longitude: lng)
        }
        
        // marker.title = "MOHALI"
        marker.icon =  UIImage(named: "Mini")
        marker.map = mapView
        mapView.camera = camera
        self.mapView?.animate(to: camera)
        //
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// webseevice
extension DriverHomeVC
{
    func updateDriverLocationApi() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let driver:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }

        let parameter:Parameters = ["driver_id":driver,"lattitude":lat,
                                    "longitude":lng,"location":"Gurdaspur"]
        
        let headers:HTTPHeaders? = ["Authorization":finalToken]
        let url =  Constant.Baseurl + "updateDriverLocation"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                print(response.result)
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "true"
                    {
                      //
                    }
                    else
                    {
                      //
                    }
                }
                
            case .failure(let error):
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
        }
        
    }
    
    func updateDriverStatusApi(status:Int) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        let driverid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        var finalToken = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            finalToken = "Bearer "+token1!
        }
        // conver int 12-Jun-2019

        let parameter:Parameters = ["driver_id":driverid,"status":status]
        
        let headers:HTTPHeaders? = ["Authorization":finalToken]
        
        let url =  Constant.Baseurl + "updateDriverStatus"
        Utility.shared.startProgress(message:"Please wait.")
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Utility.shared.stopProgress()
            switch response.result {
            case .success:
                
                print(response.result)
                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
                let dictionary = responseJSON.dictionary
                if let status = dictionary?["status"]?.string
                {
                    if status == "true"
                    {
                        //
                    }
                    else
                    {
                        //
                    }
                }
                
            case .failure(let error):
                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
                print(error)
            }
        }
    }
    
}


// MARK: - CLLocationManagerDelegate
extension DriverHomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        //
        //creating a marker on the map
        //creating a camera
        let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        //creating a marker on the map
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:lat, longitude: lng)
        
        marker.title = "MOHALI"
        marker.icon =  UIImage(named: "Mini")
        marker.map = mapView
        mapView.camera = camera
        self.mapView?.animate(to: camera)
        
        locationManager.stopUpdatingLocation()
        updateDriverLocationApi()
        // fetchNearbyPlaces(coordinate: location.coordinate)
    }
}

// MARK: - GMSMapViewDelegate
extension DriverHomeVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        // mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
}

extension DriverHomeVC // Notification Listeners
{
    private func addNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.socketConnected), name: NSNotification.Name.init(rawValue:EventNotificationName.connected.rawValue), object:nil)
    }
    
    private func removeNotification()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue:EventNotificationName.connected.rawValue), object: nil)
    }
    
    @objc private func socketConnected(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        
//        if (notification.userInfo as? [String: Any]) != nil{
//
//        }
//        let x : Int =  (UserDefaults.standard.value(forKey:"userid") as? NSInteger)!
//        let userID = String(x)
        //SocketLayer.shared.registerUser(userID:userID)
        
        let parameters:NSDictionary = ["lat": 30.7046,"lng": 76.7179,"bearing": 1,"accuracy": 2,
                                       "speed": 60,"altitude": 1]
        
        SocketLayer.shared.updateLocation(parameter:parameters)
        
    }
    
    
}
