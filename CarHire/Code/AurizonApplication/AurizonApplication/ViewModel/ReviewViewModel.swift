//
//  ReviewViewModel.swift
//  AurizonApplication
//
//  Created by QFOUR DEVELOPMENT on 1/10/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ReviewViewModel : ObservableObject {
    
    private var db = Firestore.firestore()
    
    func addReview(user: String, plate: String, expression: String, comment: String) {
        
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("reviews").addDocument(data: [
            "user": user,
            "plate": plate,
            "expression": expression,
            "comment": comment,
            "lastUpdated": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }    
}
