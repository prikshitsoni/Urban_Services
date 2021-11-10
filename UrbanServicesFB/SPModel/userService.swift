//
//  userService.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 31/03/21.
//

import Foundation
import FirebaseFirestore

class UserService {
    let database = Firestore.firestore()

    func get(collectionID: String, handler: @escaping ([appUser]) -> Void) {
        database.collection("serviceProviders")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(appUser.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}
