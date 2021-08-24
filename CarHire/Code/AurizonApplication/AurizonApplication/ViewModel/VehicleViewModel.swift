//
//  VehicleViewModel.swift
//  AurizonApplication
//
//  Created by QFOUR DEVELOPMENT on 14/9/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit
import CoreLocation

struct Registration {
    static var currentRego = ""
    static var isSheetShowing = false
}

class VehicleViewModel : ObservableObject {
    @Published var vehicles = [Vehicle]()
    @Published var currentVehicle = Vehicle(plate: "", kilometres: 0, status: "", user: "", description: "", longitude: 0.0, latitude: 0.0, address: "")
    public var category : String = "status"
    @Published var descending : Bool = false
    @Published public var currentlyHired = ""
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("vehicles").order(by: self.category, descending: self.descending).addSnapshotListener {(QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.vehicles = documents.map {(QueryDocumentSnapshot) -> Vehicle in
                let data = QueryDocumentSnapshot.data()
                
                let plate = data["plate"] as? String ?? ""
                let kilometres = data["kilometres"] as? Int ?? 0
                let status = data["status"] as? String ?? ""
                let user = data["user"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let longitude = data["longitude"] as? Double ?? 0.0
                let latitude = data["latitude"] as? Double ?? 0.0
                let address = data["address"] as? String ?? ""
                
                return Vehicle(plate: plate, kilometres: kilometres, status: status, user: user, description: description, longitude: longitude, latitude: latitude, address: address)
            }
        }
    }
    
    func findAddress(plate: String, latitude: Double, longitude: Double){
        let db = Firestore.firestore()
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var addressNum = ""
        
        geoCoder.reverseGeocodeLocation(location, completionHandler:
                                            {
                                                placemarks, error -> Void in
                                                // Place details
                                                guard let placeMark = placemarks?.first else { return }
                                                
                                                // Location name
                                                if let locationNum = placeMark.subThoroughfare {
                                                    addressNum = locationNum
                                                }
                                                // Street address
                                                if let street = placeMark.thoroughfare {
                                                    if addressNum == "" {
                                                        db.collection("vehicles").document(plate).setData([ "address" : "\(street)" ], merge: true)
                                                    }
                                                    else {
                                                        db.collection("vehicles").document(plate).setData([ "address" : "\(addressNum + " " + street)" ], merge: true)
                                                    }
                                                }
                                            })
    }
    
    func fetchCurrentVehicle() {
        
        db.collection("vehicles").whereField("plate", isEqualTo: Registration.currentRego)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.currentlyHired = "No cars hired"
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        self.currentVehicle.plate = data["plate"] as? String ?? ""
                        self.currentVehicle.kilometres = data["kilometres"] as? Int ?? 0
                        self.currentVehicle.status = data["status"] as? String ?? ""
                        self.currentVehicle.user = data["user"] as? String ?? ""
                        self.currentVehicle.description = data["description"] as? String ?? ""
                        self.currentVehicle.longitude = data["longitude"] as? Double ?? 0.0
                        self.currentVehicle.latitude = data["latitude"] as? Double ?? 0.0
                        self.currentVehicle.address = data["address"] as? String ?? ""
                    }
                }
            }
    }
    
    func updateData() {
        if currentVehicle.status == "HIRE" {
            db.collection("vehicles").document(Registration.currentRego).setData([ "status" : "HIRED", "user" : CurrentUser.user ], merge: true)
        } else {
            db.collection("vehicles").document(Registration.currentRego).setData([ "status" : "HIRE", "user" : "" ], merge: true)
        }
        
    }
    
    // gets hired cars from DB based on the email parameter
    func fetchHired(email: String) {
        db.collection("vehicles").whereField("user", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
               
                if let err = err {
                    self.currentlyHired = "No cars hired"
                    print("Error getting documents: \(err)")
                } else {
                   
                    if (querySnapshot!.count == 0){
                        self.currentlyHired = "No cars hired"
                    }
                    else{
                        self.currentlyHired = ""
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if (document.exists){
                            let data = document.data()
                            self.currentlyHired += data["plate"] as? String ?? ""
                            self.currentlyHired += "\n"
                            }
                        }
                    }
                }
                }
            }
}
