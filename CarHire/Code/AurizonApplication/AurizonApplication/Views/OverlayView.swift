//  Created by QFOUR DEVELOPMENT on 6/9/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI

// MARK: - Sheet
struct Sheet: View {
    
    @State private var showSheet = Registration.isSheetShowing
    
    var body: some View {
        
        Text("")
            .sheet(isPresented: self.$showSheet) {HireOverlay().environmentObject(showOverlay())}
            .background(Color.black.opacity(1))
    }
}

// MARK: - HireOverlay
struct HireOverlay : View {
    
    @ObservedObject private var viewModel = VehicleViewModel()
    @ObservedObject private var userModel = UserViewModel() // instantiate user model to accces mobile number
    @State var selection : Int? = nil
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var isOverlayShowing: showOverlay
    private var width = UIScreen.main.bounds.width
    private var height = UIScreen.main.bounds.height
    static var textFieldText : String = ""
    static var textFieldTextBinding = Binding<String>(get: { textFieldText }, set: {textFieldText = $0 } )
    @State private var confirmHireAlert = false
    
    
    
    init() {
        
    }
    
    var body : some View {
        
        if !Registration.isSheetShowing && !self.isOverlayShowing.observable {
            self.presentationMode.wrappedValue.dismiss()
            Registration.currentRego = ""
        }
        
        return NavigationView {
            VStack {
                
                Spacer().frame(height: height / 7)
                
                Group {
                    
                    Text(Registration.currentRego)
                        .font(Font.custom("Gotham", size: 64))
                    
                    
                    Spacer()
                    
                    Group {
                        if (viewModel.currentVehicle.user != "") {
                            Text("Vehicle is currently hired by \(viewModel.currentVehicle.user)").bold()
                                .font(Font.system(size: 24, weight: .bold))
                                .foregroundColor(.red)
                                .onAppear(){
                                    print(" current user: \(self.viewModel.currentVehicle.user)")
                                    self.userModel.fetchPhoneNum(user: self.viewModel.currentVehicle.user)
                                    
                                    print(" model phoneNum: \(self.userModel.phoneNumber)")
                                    print(" local var: \(self.userModel.phoneNumber)")
                                    //self.phoneNum = userModel.phoneNumber
                            }
                            Text("You can contact them on \(userModel.phoneNumber)").foregroundColor(.red) .font(Font.system(size: 24, weight: .bold))
                                .padding(.bottom, 10)
                            
                            //                                .onAppear(){
                            //                                    userModel.fetchPhoneNumber(user: viewModel.currentVehicle.user)
                            //                                }
                            // This needs to be called without throwing errors^^ then hopefully phone number works
                        }
                        Text("\(viewModel.currentVehicle.description)")
                            .font(Font.system(size: 24))
                        
                        Text("\(viewModel.currentVehicle.address)")
                            .font(Font.system(size: 24))
                        
                    }
                    Spacer()
                    Button(action: {
                        
                        if self.viewModel.currentVehicle.status == "HIRE" {
                            self.confirmHireAlert = true
                            
                        } else if self.viewModel.currentVehicle.user == CurrentUser.user && self.viewModel.currentVehicle.status == "HIRED" {
                            self.viewModel.updateData()
                            self.viewModel.currentVehicle.user = ""
                            self.viewModel.currentVehicle.status = "HIRE"
                            self.selection = 2
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
                
                NavigationLink(destination: ReturnButton("Leave a comment or suggestion (optional)...", text: HireOverlay.textFieldTextBinding, onCommit: {
                    print("Final text: \(HireOverlay.textFieldText)")
                }).environmentObject(showOverlay()), tag: 2, selection: self.$selection) {
                    Text("")
                }
                
                
                
                Spacer().frame(height: height / 14)
                
            }
                
            .alert(isPresented:$confirmHireAlert) {
                Alert(title: Text("Confirm Vehicle Hire"), message: Text("\(self.viewModel.currentVehicle.plate)"), primaryButton: .default(Text("Hire")) {
                    self.viewModel.updateData()
                    self.viewModel.currentVehicle.user = CurrentUser.user
                    self.viewModel.currentVehicle.status = "HIRED"
                    Registration.currentRego = ""
                    Registration.isSheetShowing = false
                    self.isOverlayShowing.observable = false
                    self.selection = 1
                    self.presentationMode.wrappedValue.dismiss()
                    }, secondaryButton: .cancel())
            }
            .onAppear() {
                self.viewModel.fetchData()
                self.viewModel.fetchCurrentVehicle()
                self.viewModel.findAddress(plate: self.viewModel.currentVehicle.plate, latitude: self.viewModel.currentVehicle.latitude, longitude: self.viewModel.currentVehicle.longitude)
            }
            .frame(width: width, height: height)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Vehicle Overview", displayMode: .inline)
            .navigationBarHidden(false)
            .navigationBarItems(trailing:
                Button(action: {
                    
                    self.presentationMode.wrappedValue.dismiss()
                    Registration.currentRego = ""
                    Registration.isSheetShowing = false
                    self.isOverlayShowing.observable = false
                    
                }){
                    Text("Cancel")
            })
                .background(Color.white)
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - HireButton
//struct HireButton : View {
//
//    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var isOverlayShowing: showOverlay
//
//    var body : some View {
//
//        Text("Hire Options go here")
//
//        .edgesIgnoringSafeArea(.all)
//        .navigationBarTitle("Hire Vehicle", displayMode: .inline)
//        .navigationBarHidden(false)
//        .navigationBarItems(trailing:
//            Button(action: {
//
//                self.presentationMode.wrappedValue.dismiss()
//                Registration.isSheetShowing = false
//                self.isOverlayShowing.isOverlayShowing = false
//
//            }){
//                Text("Done")
//        })
//            .background(Color.white)
//    }
//
//}

// MARK: - ReturnButton
struct ReturnButton : View {
    
    @ObservedObject private var viewModel = ReviewViewModel()
    
    @State private var goodButton = 1.0
    @State private var neutralButton = 1.0
    @State private var badButton = 1.0
    @State private var currentExpresion = ""
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var isOverlayShowing: showOverlay
    
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
    
    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }
    
    var body : some View {
        
        GeometryReader { geometry in
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
                    Button(action: {
                        if self.text != "" {
                            self.viewModel.addReview(user: CurrentUser.user, plate: Registration.currentRego, expression: self.currentExpresion, comment: self.text)
                        }
                        self.presentationMode.wrappedValue.dismiss()
                        Registration.isSheetShowing = false
                        self.isOverlayShowing.observable = false
                        HireOverlay.textFieldText = ""
                    }) {
                        Text("Submit")
                            .padding()
                            .frame(width: geometry.size.width / 4)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.title)
                            .cornerRadius(40)
                    }
                    Spacer()
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
