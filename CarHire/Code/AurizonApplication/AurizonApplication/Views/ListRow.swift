//  Created by QFOUR DEVELOPMENT on 9/9/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI
import Foundation
import FirebaseFirestore

enum ListAlert {
    case hiredAlert, cannotHireAlert
}

// called for each row of Hire List View
struct ListRow: View {
    var vehicle : Vehicle
    
    @ObservedObject private var viewModel = VehicleViewModel()
    @State var selection : Vehicle? = nil
    @State var showAlert = false
    @State var activeAlert: ListAlert = .hiredAlert
    //@State var hiredByAlert = false
    
    var body : some View {
        
        HStack {
            
            /* First column contents - Location */
            VStack {
                Text(verbatim: self.vehicle.address)
                    .font(.system(size: titleFont, weight: .semibold))
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .foregroundColor(aurizonTextWhite)
                
            }.frame(width: 150, height: listFrameHeight).position(x: 100, y: listFrameHeight / 2)
            
            /* Second column contents - Registration */
            VStack {
                Text(verbatim: self.vehicle.plate)
                    .font(.system(size: titleFont, weight: .semibold))
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .foregroundColor(aurizonTextWhite)
                    .onAppear {self.viewModel.findAddress(plate: self.vehicle.plate, latitude: self.vehicle.latitude, longitude: self.vehicle.longitude)}
            }.frame(width: 200, height: listFrameHeight).position(x: 100, y: listFrameHeight / 2)
            
            /* Third column contents - Availability Status */
            VStack {
                Button(action: {
                    // disable hiring and returning if tutorial is active
                    if !tutorialActive {
                        if (CurrentUser.user == self.vehicle.user && self.vehicle.status == "HIRE" || self.vehicle.user == ""){
                            
                            self.activeAlert = .hiredAlert
                            self.showAlert.toggle()
                            
                        } else if (CurrentUser.user == self.vehicle.user && self.vehicle.status == "HIRED" ){
                            
                            Registration.currentRego = self.vehicle.plate
                            self.selection = Vehicle(id: self.vehicle.id, plate: self.vehicle.plate, kilometres: self.vehicle.kilometres, status: self.vehicle.status, user: CurrentUser.user, description: self.vehicle.description, longitude: self.vehicle.longitude, latitude: self.vehicle.latitude, address: "\(self.viewModel.findAddress(plate: self.vehicle.plate, latitude: self.vehicle.latitude, longitude: self.vehicle.longitude))")
                            self.viewModel.currentVehicle = self.selection!
                            self.viewModel.updateData()
                            
                        } else {
                            
                            self.activeAlert = .cannotHireAlert
                            self.showAlert.toggle()
                            
                        }
                    } } ) {
                        /* Checks vehicle button colour schemes, assigns colour based on availabilities
                         Defines owner of hired car colour */
                        if vehicle.user == CurrentUser.user && vehicle.status == "HIRED" {
                            Text(vehicle.user == CurrentUser.user && vehicle.status == "HIRED" ? "RETURN" : vehicle.status)
                                .padding()
                                .frame(width: 120, height: 40)
                                .background(aurizonOrange)
                                .foregroundColor(.white)
                                .font(.system(size: 22, weight: .semibold))
                                .cornerRadius(40)
                                .position(x: 80, y: listFrameHeight / 2)
                        } else {
                            // Defines Available and unavailable car hires
                            Text(vehicle.user == CurrentUser.user && vehicle.status == "HIRED" ? "RETURN" : vehicle.status)
                                .padding()
                                .frame(width: 120, height: 40)
                                .background(vehicle.status == "HIRE" ? aurizonGreen : aurizonRed)
                                .foregroundColor(.white)
                                .font(.system(size: 22, weight: .semibold))
                                .cornerRadius(40)
                                .position(x: 80, y: listFrameHeight / 2)
                        }
                }
                .padding(.leading, 15)
            }.frame(height: listFrameHeight)
            
            Spacer()
                
                // Show alert based on the hire status and relevant information when tapping cell
                .alert(isPresented: self.$showAlert){
                    switch self.activeAlert {
                    case .hiredAlert:
                        return Alert(title: Text("Confirm Vehicle Hire"), message: Text("\(self.vehicle.plate)"), primaryButton: .default(Text("Hire")){
                            Registration.currentRego = self.vehicle.plate
                            self.selection = Vehicle(id: self.vehicle.id, plate: self.vehicle.plate, kilometres: self.vehicle.kilometres, status: self.vehicle.status, user: CurrentUser.user, description: self.vehicle.description, longitude: self.vehicle.longitude, latitude: self.vehicle.latitude, address: "\(self.viewModel.findAddress(plate: self.vehicle.plate, latitude: self.vehicle.latitude, longitude: self.vehicle.longitude))")
                            self.viewModel.currentVehicle = self.selection!
                            self.viewModel.updateData()
                            }, secondaryButton: .cancel())
                        
                    case .cannotHireAlert:
                        return Alert(title: Text("Cannot Hire Vehicle"), message: Text("Vehicle is currently hired by \(self.vehicle.user)"),
                                     dismissButton: .default(Text("Ok")))
                    }
            }
            
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
}

