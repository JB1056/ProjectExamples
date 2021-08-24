//
//  UserViewModel.swift
//  AurizonApplication
//
//  Created by QFOUR DEVELOPMENT on 5/10/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct CurrentUser {
    static var user = ""
    
}

class UserViewModel : ObservableObject {
    
    @Published var users = [User]()
    @Published var currentUser = User(id: "", email: "", displayName: "", photo: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Grey_Square.svg/600px-Grey_Square.svg.png", phone: "")
    
    @Published public var phoneNumber = ""
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("users").addSnapshotListener {(QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.map {(QueryDocumentSnapshot) -> User in
                let data = QueryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let displayName = data["displayName"] as? String ?? ""
                let photo = data["photo"] as? String ?? ""
                let phone = data["phone0"] as? String ?? ""
                
                return User(id: id, email: email, displayName: displayName, photo: photo, phone: phone)
            }
        }
    }
    
    func fetchCurrentUser() {
        db.collection("users").whereField("email", isEqualTo: CurrentUser.user)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        self.currentUser.id = data["id"] as? String ?? ""
                        self.currentUser.email = data["email"] as? String ?? ""
                        self.currentUser.displayName = data["displayName"] as? String ?? ""
                        self.currentUser.photo = data["photo"] as? String ?? ""
                        self.currentUser.phone = data["phone"] as? String ?? ""
                    }
                }
        }
        
    }
    
    func fetchPhoneNum(user: String) {
        db.collection("users").whereField("email", isEqualTo: user)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        self.phoneNumber = data["phone"] as? String ?? ""
                    }
                }
            }
    }
    
}
