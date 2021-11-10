//
//  ServiceProviderClass.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 05/04/21.
//

import Foundation
import MapKit

class ServiceProviderClass: NSObject, MKAnnotation {
    let title: String?
    let email : String?
    let coordinate: CLLocationCoordinate2D
    
    init(SPJobCat: String?,email : String?,coordinate: CLLocationCoordinate2D){
        self.title = SPJobCat
        self.email = email
        self.coordinate = coordinate
        
        super.init()
    }
    var subtitle: String?{
        return email
    }
    
}
