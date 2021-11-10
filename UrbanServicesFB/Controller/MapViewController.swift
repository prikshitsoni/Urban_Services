//
//  MapViewController.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 02/04/21.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseStorage

class MapViewController: UIViewController{
    
    let locationManager = CLLocationManager()
    var region = MKCoordinateRegion()
    var SelectedAnnotaionEmail = String()
    
    @IBOutlet weak var mapView: MKMapView!
    private var service: UserService?
    private var ref : DocumentReference!
    
    private var allusers = [appUser]() {
        didSet {
            DispatchQueue.main.async {
                self.users = self.allusers
            }
        }
    }
    
    var users = [appUser]() {
        didSet {
            DispatchQueue.main.async {
                self.RefreshMapMarkers()
            }
        }
    }
    
    func loadData() {
        service = UserService()
        service?.get(collectionID: "serviceProviders") { users in
            self.allusers = users
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        loadData()
        PlotMarkersOnMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocationServices()
        PlotMarkersOnMap()
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            //service is enabled
            setupLocationManager()
            checkAuthStatus()
        }
        else{
            //alert for re - enabling the services
            showLocationServicesDeniedAlert()
        }
    }
    //checking Auth status
    func checkAuthStatus(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //using for maps
            CenterViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showLocationServicesDeniedAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show alert
            let alert = UIAlertController(title:"Cannot Access location", message: "Check if your location services is turned On", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            break
        case .authorizedAlways:
            //not using
            break
        @unknown default:
            print("Unknown Status")
        }
    }
    
    //alert for denial to access location
    func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
        present(alert, animated: true, completion: nil)
        alert.addAction(okAction)
    }
    
    //Ploting Marker
    func PlotMarkersOnMap(){
        for user in users {
            let SPMarker = ServiceProviderClass(SPJobCat: user.jobCat!, email: user.email,coordinate: CLLocationCoordinate2DMake(user.Latitude!, user.Longitude!))
            mapView.addAnnotation(SPMarker)
        }
    }
    //Removing Marker
    func RemoveMarkerFromMap(){
        for user in users {
            let SPMarker = ServiceProviderClass(SPJobCat: user.jobCat!, email: user.email,coordinate: CLLocationCoordinate2DMake(user.Latitude!, user.Longitude!))
            mapView.removeAnnotation(SPMarker)
        }
    }
    
    //refresh Markers
    func RefreshMapMarkers(){
        RemoveMarkerFromMap()
        PlotMarkersOnMap()
    }
    
    //setting region for user location
    func CenterViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location,latitudinalMeters: 10000,longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //fetching image from FireBase
    func fetchImage(ImageView : UIImageView , email : String , ErrorLabel : UILabel){
        let ref = Storage.storage().reference(withPath: "ServiceProviderImages"+"/"+"image"+email)
        ref.getData(maxSize: (1*2048*2048)) { (data, error) in
            if error != nil
            {
                print(error!)
                ErrorLabel.alpha = 1
                ErrorLabel.text = "cannot fetch image"
            }
            else{
                ImageView.image = UIImage(data: data!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let db = Firestore.firestore()
        ref =  db.collection("serviceProviders").document("\(SelectedAnnotaionEmail)")
        ref.getDocument { (data, error) in
            if let data = data {
                let infoData = data.data()!
                let destVC = segue.destination as? SPDetailViewController

                destVC?.Name.text = infoData["fullName"] as? String
                destVC?.Age.text = infoData["age"] as? String
                destVC?.Contact.text = infoData["contact"] as? String
                destVC?.Gender.text = infoData["gender"] as? String
                destVC?.Category.text = infoData["jobCategory"] as? String
                destVC?.Description.text = infoData["jobDescription"] as? String
                destVC?.Address.text = infoData["address"] as? String
                destVC?.SPEmail.text = infoData["email"] as? String
                self.fetchImage(ImageView: (destVC?.SPImage)!, email: self.SelectedAnnotaionEmail, ErrorLabel: (destVC?.SPError)!)
            }
        }
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Did Update Location
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate
                                                .longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Check for Authorization
        checkAuthStatus()
    }
}
//moving to SPDetailViewController
extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        SelectedAnnotaionEmail = (view.annotation?.subtitle)!!
        performSegue(withIdentifier: "MoveToSPDetail", sender: MapViewController.self)
    }
}

