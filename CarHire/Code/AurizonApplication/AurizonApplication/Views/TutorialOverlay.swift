//  Created by QFOUR DEVELOPMENT on 6/9/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI

// MARK: - HireOverlay
struct tutorialHireOverlay : View {
    
    @ObservedObject private var viewModel = VehicleViewModel()
    @State var selection : Int? = nil
    @State var info = overlayInfo
    private var width = UIScreen.main.bounds.width
    private var height = UIScreen.main.bounds.height
    static var textFieldText : String = ""
    static var textFieldTextBinding = Binding<String>(get: { textFieldText }, set: {textFieldText = $0 } )
    @State private var confirmHireAlert = false
    
    var body : some View {
        
        Registration.currentRego = "123-ABC"
        
        return
            ZStack {
                if tutorialActive {
                    if self.info {
                        VStack {
                            Text("Hire or return vehicle").font(.system(size: titleFont+6, weight: .semibold)).multilineTextAlignment(.center)
                            
                            Text("Hire available vehicles or return already hired vehicles. If a vehicle is already hired, the contact information of the hiring person is shown").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                            
                            HStack {
                                Button(action: { self.info = false; overlayInfo = false; }) {
                                    Text("OK")
                                        .font(.system(size: bodyFont, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                        .background(RoundedRectangle(cornerRadius: 40)
                                            .foregroundColor(aurizonOrange)).padding()
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 250)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .zIndex(8)
                    }
                    // Initiate Tutorial Widget
                    TutorialFlow().zIndex(8)
                }
                
                VStack {
                    
                    Spacer().frame(height: height / 7)
                    
                    Group {
                        
                        Text(Registration.currentRego)
                            .font(Font.custom("Gotham", size: 64))
                        
                        Spacer()
                        
                        Group {
                            if (viewModel.currentVehicle.user != "") {
                                Text("This vehicle is currently hired by \(viewModel.currentVehicle.user)").bold()
                                    .font(Font.custom("Gotham", size: 24))
                                    .foregroundColor(.red)
                            }
                            Text("\(viewModel.currentVehicle.description)")
                                .font(Font.custom("Gotham", size: 24))
                            
                            Text("\(viewModel.currentVehicle.address)")
                                .font(Font.custom("Gotham", size: 24))
                            
                        }
                        Spacer()
                        Button(action: {
                            
                            if self.viewModel.currentVehicle.status == "HIRE" {
                                self.confirmHireAlert = true
                                
                            } else if self.viewModel.currentVehicle.user == CurrentUser.user && self.viewModel.currentVehicle.status == "HIRED" {
                                self.viewModel.updateData()
                                self.viewModel.currentVehicle.user = ""
                                self.viewModel.currentVehicle.status = "HIRE"
                                self.selection = 3
                            }
                            
                        }) {
                            
                            // Checks vehicle button colour schemes, assigns colour based on availabilities
                            // Defines owner of hired car return button colour
                            if viewModel.currentVehicle.user == CurrentUser.user
                                && viewModel.currentVehicle.status == "HIRED" {
                                Text(viewModel.currentVehicle.user == CurrentUser.user && viewModel.currentVehicle.status == "HIRED" ? "RETURN" : viewModel.currentVehicle.status)
                                    .padding()
                                    .frame(width: 240)
                                    .background(aurizonOrange)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .cornerRadius(40)
                                    .shadow(radius: 10)
                            } else {
                                Text(viewModel.currentVehicle.user == CurrentUser.user && viewModel.currentVehicle.status == "HIRED" ? "RETURN" : viewModel.currentVehicle.status)
                                    .padding()
                                    .frame(width: 240)
                                    .background(viewModel.currentVehicle.status == "HIRE" ? aurizonGreen : aurizonRed)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .cornerRadius(40)
                                    .shadow(radius: 10)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        Spacer()
                        
                        Button(action: {
                            self.viewModel.fetchCurrentVehicle()
                        }) {
                            Text("Update Location")
                        }
                        
                    }
                    
                    GoogleMapViewControllerWrapper(lon: $viewModel.currentVehicle.longitude, lat: $viewModel.currentVehicle.latitude).frame(width: width / 1.2)
                    
                }
                .onAppear() {
                    self.viewModel.fetchData()
                    self.viewModel.fetchCurrentVehicle()
                    self.viewModel.findAddress(plate: self.viewModel.currentVehicle.plate, latitude: self.viewModel.currentVehicle.latitude, longitude: self.viewModel.currentVehicle.longitude)
                }
                .frame(width: width, height: height)
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
}

// MARK: - ReturnButton
struct tutorialReturnButton : View {
    
    @ObservedObject private var viewModel = ReviewViewModel()
    
    @State private var goodButton = 1.0
    @State private var neutralButton = 1.0
    @State private var badButton = 1.0
    @State private var currentExpresion = ""
    
    private var placeholder: String
    private var onCommit: (() -> Void)?
    
    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }
    
    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false
    @State var info = feedbackInfo
    
    
    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }
    
    var body : some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                // Tutorial Popup Card
                if tutorialActive {
                    if self.info {
                        VStack {
                            Text("Return your vehicle and submit your experience").font(.system(size: titleFont * 0.9, weight: .semibold)).multilineTextAlignment(.center)
                            
                            Text("Select the feeling associated with the trip in the vehicle").font(.system(size: bodyFont, weight: .semibold)).multilineTextAlignment(.center).padding()
                            
                            Text("This view allows users to provide insight into their experience with the particular hired vehicle, helping identify issues with vehicles before the problem escalates.").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                            
                            HStack {
                                Button(action: { self.info = false; feedbackInfo = false; }) {
                                    Text("OK")
                                        .font(.system(size: bodyFont, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                        .background(RoundedRectangle(cornerRadius: 40)
                                            .foregroundColor(aurizonOrange)).padding()
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 325)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .zIndex(8)
                    }
                    // Initiate Tutorial Widget
                    TutorialFlow().zIndex(8)
                }
                
                VStack {
                    Group {
                        Spacer()
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(Color.green)
                            .frame(width: geometry.size.width / 4, height: geometry.size.width / 4)
                        Spacer()
                        Text("Thanks \(CurrentUser.user)").font(Font.custom("Gotham", size:  36)).padding()
                        Text("How was your experience driving this vehicle?").font(Font.custom("Gotham", size: 24)).padding()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            self.goodButton = 0.1
                            self.neutralButton = 0.1
                            self.badButton = 1
                            self.currentExpresion = "bad"
                        }) {
                            Image("bad").resizable().frame(width: 128, height: 128).foregroundColor(.red).opacity(self.badButton)
                        }
                        Spacer()
                        Button(action: {
                            self.goodButton = 0.1
                            self.neutralButton = 1
                            self.badButton = 0.1
                            self.currentExpresion = "neutral"
                        }) {
                            Image("neutral").resizable().frame(width: 128, height: 128).foregroundColor(.yellow).opacity(self.neutralButton)
                        }
                        Spacer()
                        Button(action: {
                            self.goodButton = 1
                            self.neutralButton = 0.1
                            self.badButton = 0.1
                            self.currentExpresion = "good"
                        }) {
                            Image("good").resizable().frame(width: 128, height: 128).foregroundColor(.green).opacity(self.goodButton)
                        }
                        Spacer()
                    }
                    Group {
                        Spacer()
                        UITextViewWrapper(text: self.internalText, calculatedHeight: self.$dynamicHeight, onDone: self.onCommit)
                            .frame(width: geometry.size.width / 2, height: geometry.size.height / 6)
                            .background(self.placeholderView, alignment: .topLeading)
                        Spacer()
                        Spacer()
                    }
                    
                }
            }
            .keyboardResponsive()
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Returned", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(false)
            .background(Color.white)
        }
    }
    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}


