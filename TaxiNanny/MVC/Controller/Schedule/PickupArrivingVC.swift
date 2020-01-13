//
//  PickupArrivingVC.swift
//  TaxiNanny
//
//  Created by ip-d on 24/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsDirections

class PickupArrivingVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationNameView: CardView!
    
    private let locationManager = CLLocationManager()
    private let searchRadius: Double = 1000
    
    private var pathPoints:GMSMutablePath = GMSMutablePath()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI()  {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        self.mapView.addSubview(locationNameView)
        self.view.addSubview(mapView)
        
        Direction()
       
        
//        let marker1 = GMSMarker()
//        marker1.position = CLLocationCoordinate2D(latitude:30.7333, longitude:76.6677)
//        //marker.title = "MOHALI"
//        marker1.map = mapView
    }

    // Marks - Button Method
    
    @IBAction func back(_ sender: Any) {
        // self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func call(_ sender: Any) {
        
        let num = "01724000503"
        guard let number = URL(string: "tel://" + num) else { return }
        UIApplication.shared.open(number)
    
    }
    
    func Direction() {
        
        GoogleMapsDirections.provide(apiKey:googleApiKey)
    
        let origin  = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D(latitude:30.7099, longitude:76.7068))

        let destination  = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D(latitude:30.7333, longitude:76.6677))
        
        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
            // Check Status Code
            guard response?.status == GoogleMapsDirections.StatusCode.ok else {
                Utility.shared.showSnackBarMessage(message:response?.errorMessage ?? "Something went wrong!")
                return
            }
    
            // if have get the routes
            if let routes:[GoogleMapsDirections.Response.Route] = response?.routes
            {
                if let steps = routes.first?.legs.first?.steps
                {
                    self.pathPoints.removeAllCoordinates()
                    for step in steps
                    {
                        let polylineStartPoint = step.startLocation
                        let polylineEndPoint = step.endLocation
                        
                        if self.pathPoints.count() > 0
                        {
                             self.pathPoints.addLatitude(polylineEndPoint!.latitude, longitude: polylineEndPoint!.longitude)
                        }
                        else
                        {
                            self.pathPoints.addLatitude(polylineStartPoint!.latitude, longitude: polylineStartPoint!.longitude)
                            self.pathPoints.addLatitude(polylineEndPoint!.latitude, longitude: polylineEndPoint!.longitude)
                        }
                        
                    }
                    self.updatePath()
                    return
                }
                Utility.shared.showSnackBarMessage(message:"There is no routes")
                return
            }
            
            // if there is no routes
            Utility.shared.showSnackBarMessage(message:"There is no routes")

        }
        
     
        
    }
    
    //Method
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
extension PickupArrivingVC: CLLocationManagerDelegate {
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
        
        locationManager.stopUpdatingLocation()
        // fetchNearbyPlaces(coordinate: location.coordinate)
    }
}

// MARK: - GMSMapViewDelegate
extension PickupArrivingVC: GMSMapViewDelegate {
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

extension PickupArrivingVC // only map related function here
{
    func updatePath()
    {
        mapView.clear()
        let polyline = GMSPolyline(path:pathPoints)
        polyline.strokeWidth = 2.0
        polyline.geodesic = true
        polyline.map = mapView
        polyline.strokeColor = .darkGray
        
        setPickUpMarker()
        setDropMarker()
    }
    
    func setPickUpMarker()
    {
        let marker = GMSMarker()
        let position = pathPoints.coordinate(at:0)
        marker.position = CLLocationCoordinate2D(latitude:position.latitude, longitude:position.longitude)
        marker.map = mapView
        
        let camera = GMSCameraPosition(latitude:position.latitude, longitude:position.longitude, zoom: 15)
        mapView.camera = camera
        self.mapView?.animate(to: camera)
    }
    
    func setDropMarker()
    {
        let marker = GMSMarker()
        let position = pathPoints.coordinate(at:pathPoints.count() - 1)
        marker.position = CLLocationCoordinate2D(latitude:position.latitude, longitude:position.longitude)
        marker.map = mapView
    }
    
}

