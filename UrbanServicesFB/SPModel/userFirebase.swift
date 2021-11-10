//
//  userFirebase.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 31/03/21.
//

import Foundation
import FirebaseFirestore

extension appUser {
    static func build(from documents: [QueryDocumentSnapshot]) -> [appUser] {
        var users = [appUser]()
        for document in documents {
            users.append(appUser(fullName: document["fullName"] as? String ?? "", age: document["age"] as? String ?? "", contact: document["contact"] as? String ?? "", gender: document["gender"] as? String ?? "", jobCat: document["jobCategory"] as? String ?? "", jobDesc: document["jobDescription"] as? String ?? "", email: document["email"] as? String ?? "", status: document["status"] as? String ?? "" , address: document["address"] as? String ?? "" , Latitude: document["latitude"] as? Double ?? 0.0, Longitude: document["longitude"] as? Double ?? 0.0))
        }
        return users
    }
}


