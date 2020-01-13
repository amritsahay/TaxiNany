//
//  Pickup-and-droupoffVC.swift
//  TaxiNanny
//
//  Created by ip-d on 14/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Stripe
import GoogleMaps
import GooglePlaces
import MapKit

enum Location{
    case pickupLocation
    case dropLocation
}

class customPin:NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String,location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

class Pickup_and_droupoffVC: UIViewController, MKMapViewDelegate{
    
    
    @IBOutlet weak var droplocation: UILabel!
    @IBOutlet weak var pickuplocation: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    // @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var list_View: UICollectionView!
    var locationManager = CLLocationManager()
    var locationSelected = Location.pickupLocation
    var drop = CLLocation()
    var pickup = CLLocation()
    var riderlistmodel = [RiderDetailmodel]()
    var distance:Double = 0
    var time:Double = 0
    var vardate:String = ""
    var vartime:String = ""
    var estimatePrice:String = ""
    var amount:Double = 15.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        riderlistmodel = CommmanFunction.getriderdetails()
       
        self.mapView.delegate = self
        list_View.register(UINib(nibName:"RiderCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:"RiderCollectionViewCell")
        
        
    }
    
    func setMap(startlat:Double,startlng:Double,endlat:Double,endlng:Double)
    {
        let startLocation = CLLocationCoordinate2D(latitude: startlat as! CLLocationDegrees, longitude: startlng as! CLLocationDegrees )
        let endLocation = CLLocationCoordinate2D(latitude: endlat as! CLLocationDegrees, longitude: endlng as! CLLocationDegrees)
        let sourcePin = customPin(pinTitle: riderlistmodel[0].pickuplocation, pinSubTitle: "", location: startLocation)
        let destinationPin = customPin(pinTitle: riderlistmodel[0].droplocation, pinSubTitle: "", location: endLocation)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        let sourcePlacemark = MKPlacemark(coordinate: startLocation)
        let destinationPlacemark = MKPlacemark(coordinate: endLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
         directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let error = error{
                    print("Not getting directions\(error.localizedDescription)")
                }
                return
            }
            let route = directionResponse.routes[0]
            let d = route.distance
            let t = route.expectedTravelTime
            self.distance = round(d *  0.00062137)
            self.time = round(t / 60)

            
//            self.mapView.addOverlay(route.polyline)
//
           // self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            self.list_View.reloadData()
        }
        
        
      
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    // Marks - Button Method
    @IBAction func back(_ sender: Any) {
        // self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuebtn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewcontrol:PaymentViewController = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        viewcontrol.estimatePrice = self.estimatePrice
        viewcontrol.amount = self.amount
        viewcontrol.date = self.vardate
        viewcontrol.time = self.vartime
        self.navigationController?.pushViewController(viewcontrol, animated: true)
        //                let addCardViewController = STPAddCardViewController()
        //                addCardViewController.delegate = self
        //                // STPAddCardViewController must be shown inside a UINavigationController.
        //                let navigationController = UINavigationController(rootViewController: addCardViewController)
        //                self.present(navigationController, animated: true, completion: nil)
        
        
        //bookingApi()
        
        //PickupArrivingVC
        //        let selectRider = self.storyboard?.instantiateViewController(withIdentifier:"Listofday") as! Listofday
        //        self.navigationController?.pushViewController(selectRider, animated:true)
        
    }
    
    
}

extension Pickup_and_droupoffVC:STPAddCardViewControllerDelegate{
    
    // payment
    
    /**
     *  Called when the user cancels adding a card. You should dismiss (or pop) the view controller at this point.
     *
     *  @param addCardViewController the view controller that has been cancelled
     */
    public func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     *  This is called when the user successfully adds a card and tokenizes it with Stripe. You should send the token to your backend to store it on a customer, and then call the provided `completion` block when that call is finished. If an error occurred while talking to your backend, call `completion(error)`, otherwise, dismiss (or pop) the view controller.
     *
     *  @param addCardViewController the view controller that successfully created a token
     *  @param token                 the Stripe token that was created. @see STPToken
     *  @param completion            call this callback when you're done sending the token to your backend
     */
    public func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        print("token===>\(token)")
        print("token===>\(String(describing: token.card?.cardId))")
        print("token===>\(String(describing: token.card?.label))") //("Visa 7648"), ("MasterCard 1394"), ("American Express 1257"), ("Discover 9621")
        print("tokenExpMonth===>\(String(describing: token.card?.expMonth))")
        print("tokenExpYear===>\(String(describing: token.card?.expYear))")
        
        print("added card")
        
        STPCardValidator.validationState(forExpirationYear: String(describing: token.card?.expYear), inMonth: String(describing: token.card?.expMonth))
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension Pickup_and_droupoffVC: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return riderlistmodel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RiderCollectionViewCell", for: indexPath as IndexPath) as! RiderCollectionViewCell
        //Cell
        cell.ridername.text = riderlistmodel[indexPath.row].first_name
        cell.estimatedDistance.text = String(self.distance) + " miles"
        cell.estimatedTime.text = String(self.time) + " mins"
        if self.distance < 3.1{
            cell.estimatePrice.text = "$15.00"
            self.estimatePrice = "$15.00"
        }else{
            let remd = self.distance - 3.0
            let cal = (remd * 1.50) + 15
            self.amount = cal
            self.estimatePrice = "$" + String(cal)
            cell.estimatePrice.text = estimatePrice
        }
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return riderlistmodel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        mapView.removeAnnotations(mapView.annotations)
        droplocation.text = riderlistmodel[indexPath.row].droplocation
        pickuplocation.text = riderlistmodel[indexPath.row].pickuplocation
        setMap(startlat: Double(riderlistmodel[indexPath.row].pickuplat) as! Double, startlng: Double(riderlistmodel[indexPath.row].pickuplog) as! Double, endlat: Double(riderlistmodel[indexPath.row].droplat) as! Double, endlng: Double(riderlistmodel[indexPath.row].droplog) as! Double)
       
    }
}

extension Pickup_and_droupoffVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = list_View.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


// webseevice
extension Pickup_and_droupoffVC
{
    func EstimatedFareAndTimeApi() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let token1 =  UserDefaults.standard.value(forKey:"token") as? String
        //let parentid:Int = (UserDefaults.standard.value(forKey:"userid") as? Int)!
        let finalToken = "Bearer "+token1!
        var headerValue = ""
        
        if let _ = token1, !token1!.isEmpty {
            /* string is not blank */
            headerValue = finalToken
        }
        
        //        let parameter:JSON = {"ride_detail": [{
        //            "rider_pick_location_id": "159",
        //            "rider_drop_location_id": "160"
        //            },
        //            {
        //            "rider_pick_location_id": "161",
        //            "rider_drop_location_id": "162"
        //            }]
        //        }
        
        //        let parameter:Parameters = ["rider_id":riderid!,"locaion_name":lAddress,"lattitude":lLatitude,"longitude":lLongitude,"nick_name":name.text!,"description":note.text!]
        
        //        let headers:HTTPHeaders? = ["Authorization":headerValue]
        //
        //        let url = Constant.Baseurl + "estimatedFareAndTime"
        //        Utility.shared.startProgress(message:"Please wait.")
        //
        //        Alamofire.request(url, method: .post, parameters: parameter, encoding:URLEncoding.default, headers: headers).validate().responseString { (response) in
        //            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //            switch response.result {
        //            case .success:
        //                Utility.shared.stopProgress()
        //                print(response.result)
        //                let responseJSON = JSON.init(parseJSON:response.value ?? "{}")
        //                let dictionary = responseJSON.dictionary
        //                if let status = dictionary?["status"]?.string
        //                {
        //                    if status == "true"
        //                    {
        //                        //
        //                        let selectRider = self.storyboard?.instantiateViewController(withIdentifier:"SelectedRiderVC") as! SelectedRiderVC
        //                        self.navigationController?.pushViewController(selectRider, animated:true)
        //                    }
        //                    else
        //                    {
        //                        //
        //                    }
        //                }
        //
        //            case .failure(let error):
        //                Utility.shared.stopProgress()
        //                Utility.shared.showSnackBarMessage(message:error.localizedDescription)
        //                print(error)
        //            }
        //        }
    }
    
    
    
    
    
}

