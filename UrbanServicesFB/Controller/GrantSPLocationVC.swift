//
//  GrantSPLocationVC.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 05/04/21.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage

class GrantSPLocationVC: UIViewController ,CLLocationManagerDelegate {

    var Lati = Double()
    var Longi = Double()
    var Address = String()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Location button
    @IBAction func LocationBTN(_ sender: Any) {
        if(CLLocationManager.authorizationStatus() == .notDetermined){
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        }
        else{
            let alert = UIAlertController(title: "Thank you", message: "we already know your location", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        Lati = locValue.latitude
        Longi = locValue.longitude
    }
    
    //Getting address from Latitude Longitude
    func getAddressFromLatLon(latitude: Double,longitude: Double) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = latitude
            center.longitude = longitude
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        { [self](placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
                        let name = pm.name
                        let streetName = pm.thoroughfare
                        let streeNumber = pm.subThoroughfare
                        let city = pm.locality
                        let state = pm.administrativeArea
                        let subState = pm.subAdministrativeArea
                        let zipCode = pm.postalCode
                        let IsoCountryCode = pm.isoCountryCode
                         Address = "\(name ?? "") "+"\(streetName ?? "") "+"\(streeNumber ?? "") "+"\(city ?? "") "+"\(state ?? "") "+"\(subState ?? "") "+"\(zipCode ?? "") "+"\(IsoCountryCode ?? "") "
                  }
            })
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "MoveToSPReg")
        {
            let destVC = segue.destination as! ServiceProviderRegVC
            destVC.address = Address
            destVC.LatRec = Lati
            destVC.LongRec = Longi
        }
    }
    
    //Next Button
    @IBAction func NextBTN(_ sender: UIBarButtonItem) {
        getAddressFromLatLon(latitude: Lati, longitude: Longi)
        performSegue(withIdentifier: "MoveToSPReg", sender: GrantUserLocationVC.self)
    }
}
