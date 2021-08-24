//  Created by QFOUR DEVELOPMENT on 20/8/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI
import Introspect
import Foundation

class showOverlay: ObservableObject {
    @Published var observable = false
}

// MARK: - Manual Hire

struct HireView: View {
    
    // OTP STATES
    @State private var containerArray = ["", "", "", "", "", ""]
    @State private var containerBools = [true, true, true, true, true, true]
    
    
    // OTHER STATES
    @State var showMenu = false
    @State var rego : String = ""
    @EnvironmentObject var isOverlayShowing: showOverlay
    @State var showAlert = false
    @State var updater : Bool = false
    @State var info = hireInfo
    @ObservedObject private var viewModel = VehicleViewModel()
    
    // Runs different frame parameters if on iPad
    @State private var ipadRes : Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        
        // check registration exists in DB using manual input
        func checkExists(rego: String) -> Bool {
            // this function will change with database implementation
            var exists = false
            for vehicle in viewModel.vehicles {
                if (rego == vehicle.plate){
                    print("Found matching registration")
                    exists = true
                    break
                }
            }
            return exists
        }
        
        let drag = DragGesture().onEnded {
            if $0.translation.height > -100 {
                withAnimation {
                    self.showMenu = true
                    
                }
            }
            if $0.translation.height < -100 {
                withAnimation {
                    self.showMenu = false
                }
            }
        }
        
        if showMenu {
            self.hideKeyboard()
        }
        
        if containerArray[5] != "" {
            self.hideKeyboard()
        }
        
        return GeometryReader { geometry in
            
            ZStack {
                
                VStack {
                    
                    Text("Please enter vehicle's registration")
                        .foregroundColor(textColour)
                        .font(Font.custom("Gotham", size: 34))
                        .padding(.bottom, 25)
                    
                    HStack {
                        Group {
                            Spacer()
                            Spacer()
                        }
                        
                        TextField(" ", text: self.$containerArray[0])
                            .frame(width: 70, height: nil)
                            .padding(.all, 5)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font.system(size: 60, design: .default))
                            .multilineTextAlignment(.center)
                            .onAppear { self.containerArray[0] = "" }
                            .introspectTextField { generatedTF in
                                if self.containerArray[0] == "" && !self.showMenu && !Registration.isSheetShowing {
                                    generatedTF.becomeFirstResponder() } }
                        
                        if self.containerArray[0] != "∂" {
                            TextField(" ", text: self.$containerArray[1])
                                .frame(width: 70, height: nil)
                                .padding(.all, 5)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(Font.system(size: 60, design: .default))
                                .multilineTextAlignment(.center)
                                .onAppear { self.containerArray[1] = "" }
                                .introspectTextField { generatedTF in
                                    if self.containerArray[0] != "" && self.containerBools[0] {
                                        generatedTF.becomeFirstResponder()
                                        self.containerBools[0] = false } } }
                        
                        if self.containerArray[1] != "∂" {
                            TextField(" ", text: self.$containerArray[2])
                                .frame(width: 70, height: nil)
                                .padding(.all, 5)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(Font.system(size: 60, design: .default))
                                .multilineTextAlignment(.center)
                                .onAppear { self.containerArray[2] = "" }
                                .introspectTextField { generatedTF in
                                    if self.containerArray[1] != "" && self.containerBools[1] {
                                        generatedTF.becomeFirstResponder()
                                        self.containerBools[1] = false } } }
                        
                        Text("-")
                            .frame(width: 70, height: nil)
                            .padding(.all, 5)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font.system(size: 60, design: .default))
                            .multilineTextAlignment(.center)
                        
                        
                        if self.containerArray[2] != "∂" {
                            TextField(" ", text: self.$containerArray[3])
                                .frame(width: 70, height: nil)
                                .padding(.all, 5)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(Font.system(size: 60, design: .default))
                                .multilineTextAlignment(.center)
                                .onAppear { self.containerArray[3] = "" }
                                .introspectTextField { fourthTextField in
                                    if self.containerArray[2] != "" && self.containerBools[2] {
                                        fourthTextField.becomeFirstResponder()
                                        self.containerBools[2] = false
                                    }
                            }
                        }
                        
                        if self.containerArray[3] != "∂" {
                            TextField(" ", text: self.$containerArray[4])
                                .frame(width: 70, height: nil)
                                .padding(.all, 5)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(Font.system(size: 60, design: .default))
                                .multilineTextAlignment(.center)
                                .onAppear { self.containerArray[4] = "" }
                                .introspectTextField { generatedTF in
                                    if self.containerArray[3] != "" && self.containerBools[3] {
                                        generatedTF.becomeFirstResponder()
                                        self.containerBools[3] = false
                                    }
                            }
                        }
                        
                        if self.containerArray[4] != "∂" {
                            TextField(" ", text: self.$containerArray[5])
                                .frame(width: 70, height: nil)
                                .padding(.all, 5)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(Font.system(size: 60, design: .default))
                                .multilineTextAlignment(.center)
                                .onAppear { self.containerArray[5] = "" }
                                .introspectTextField { generatedTF in
                                    if self.containerArray[4] != "" && self.containerBools[4] {
                                        generatedTF.becomeFirstResponder()
                                        self.containerBools[4] = false
                                    }
                            }
                        }
                        Group {
                            Spacer()
                            Spacer()
                        }
                    }
                    
                    VStack {
                        // Resets states of the OTP containers
                        Button(action: {
                            self.containerArray = ["", "", "", "", "", ""]
                            self.containerBools = [true, true, true, true, true, true]
                        }){
                            Text("Clear").foregroundColor(textColour)
                        }.padding(.top, 25)
                        
                        // Hire button implementation & positioning
                        Button(action: {
                            
                            if tutorialActive {
                                Registration.currentRego = "123-ABC"
                                Registration.isSheetShowing = true
                                self.isOverlayShowing.observable.toggle()
                                
                                //Reset search OTP states
                                self.containerArray = ["", "", "", "", "", ""]
                                self.containerBools = [true, true, true, true, true, true]
                            }
                            else {
                                if(checkExists(rego: self.containerArray[0] + self.containerArray[1] + self.containerArray[2] + "-" + self.containerArray[3] + self.containerArray[4] + self.containerArray[5])){
                                    
                                    
                                    Registration.currentRego = self.containerArray[0] + self.containerArray[1] + self.containerArray[2] + "-" + self.containerArray[3] + self.containerArray[4] + self.containerArray[5]
                                    
                                    Registration.isSheetShowing = true
                                    self.isOverlayShowing.observable.toggle()
                                    
                                    //                                 Reset search OTP states
                                    self.containerArray = ["", "", "", "", "", ""]
                                    self.containerBools = [true, true, true, true, true, true]
                                }
                                    
                                else {
                                    // Promp error alert over invalid numberplate
                                    self.showAlert.toggle()
                                    self.containerArray = ["", "", "", "", "", ""]
                                    self.containerBools = [true, true, true, true, true, true]
                                }
                            }
                        }
                        ){
                            Text("Search")
                                .frame(width: self.ipadRes ? LoginView.ipadWidth - 150: LoginView.iphoneWidth, height: 60 )
                                .background(RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(aurizonOrange))
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                            
                        .padding(.top, 25)
                        .alert(isPresented: self.$showAlert){
                            Alert(title: Text("Vehicle Not Found"), message: Text("Please check registration"), dismissButton: .default(Text("Ok")))
                        }
                    }
                }
                
                if self.showMenu {
                    TileMenuView()
                        .transition(.move(edge: .top))
                        .scaledToFill()
                }
                
                if self.isOverlayShowing.observable {
                    Sheet().zIndex(9)
                }
                
                if !self.isOverlayShowing.observable {
                    Sheet().zIndex(9)
                }
                
                ZStack {
                    // Tutorial Popup Card
                    if tutorialActive {
                        if self.info {
                            VStack {
                                Text("Enter Registration of desired vehicle").font(.system(size: titleFont+6, weight: .semibold))
                                
                                Text("For Demonstration purposes, please enter \"123-ABC\"*").font(.system(size: bodyFont, weight: .semibold)).multilineTextAlignment(.center).padding()
                                
                                Text("Enter the registration plate of a registered vehicle, you may hire or return vehicles through this method. If a vehicle is already hired, the contact information of the current hire can be seen").font(.system(size: bodyFont)).multilineTextAlignment(.center)
                                
                                Text("*Registration used for demonstration purposes").font(.system(size: bodyFont, weight: .semibold)).multilineTextAlignment(.center).padding()
                                HStack{
                                    Button(action: { self.info = false; hireInfo = false; }) {
                                        Text("OK")
                                            .font(.system(size: bodyFont, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                            .background(RoundedRectangle(cornerRadius: 40)
                                                .foregroundColor(aurizonOrange)).padding(15)
                                    }
                                }
                            }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 350)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                                .zIndex(10)
                        }
                        
                        TutorialFlow().zIndex(10)
                        
                    }
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }.onAppear() { self.viewModel.fetchData() }
                .frame(width: UIScreen.main.bounds.width - 50, height: 450)
                .background(RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(backgroundColour))
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .padding(.top, 15)
                .background(Image("TrackBG").resizable().scaledToFill().blur(radius:12))
                .edgesIgnoringSafeArea(.all)
        }.gesture(drag)
    }
}

struct HireView_Previews: PreviewProvider {
    static var previews: some View {
        HireView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

