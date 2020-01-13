//
//  ParentHomeVC.swift
//  TaxiNanny
//
//  Created by ip-d on 24/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import Stripe
import GoogleMaps

class ParentHomeVC: UIViewController {

 
    @IBOutlet weak var scheduleView: BorderView!
    @IBOutlet weak var schedule: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    private let searchRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
       
        self.scheduleView.addSubview(schedule)
        self.mapView.addSubview(scheduleView)
        self.view.addSubview(mapView)
        
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 20)
        
        var scheduleTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(ParentHomeVC.scheduleTime), userInfo: nil, repeats: false)
    }
    
    @objc func scheduleTime()
    {
        NSLog("schedule")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"WelcomeVC")
        self.navigationController?.pushViewController(vc!, animated: true)
       // self.present(vc!, animated: true, completion: nil)
    }

     //Mark - Button method
     @IBAction func schedule(_ sender: Any) {
        
        let rider_form = self.storyboard?.instantiateViewController(withIdentifier:"AddRidersVC") as! AddRidersVC
        self.navigationController?.pushViewController(rider_form, animated:true)
    }
    
    @IBAction func menu(_ sender: Any) {
        AppDelegate.shared.openDrawer()
    }
   
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
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


// MARK: - CLLocationManagerDelegate
extension ParentHomeVC: CLLocationManagerDelegate {
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
        
        //
        //creating a marker on the map
        //creating a camera
        let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        //this is our map view
        
        //creating a marker on the map
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
        //marker.title = "MOHALI"
        marker.map = mapView
        mapView.camera = camera
        self.mapView?.animate(to: camera)
        
        //
        
       // self.mapView?.animate(to: camera)
        
        locationManager.stopUpdatingLocation()
       // fetchNearbyPlaces(coordinate: location.coordinate)
    }
}

// MARK: - GMSMapViewDelegate
extension ParentHomeVC: GMSMapViewDelegate {
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

