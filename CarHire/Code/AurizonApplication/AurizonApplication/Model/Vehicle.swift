//
//  Vehicle.swift
//  AurizonApplication
//
//  Created by Samuel Bridgewater on 8/9/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import Foundation

struct Vehicle: Identifiable {
    var id: String = UUID().uuidString
    var plate: String
    var kilometres: Int
    var status: String
    var user: String
    var description: String
    var longitude: Double
    var latitude: Double
    var address: String
}
