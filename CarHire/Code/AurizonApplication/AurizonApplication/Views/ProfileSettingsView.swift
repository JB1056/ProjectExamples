//  Created by QFOUR DEVELOPMENT on 3/10/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum ActiveAlert {
    case weakPassword, passwordMissMatch, passwordChangeSuccess, invalidEmail, mustReturnVehicle,  emailChangeSuccess, wrongEmail, phoneChangeSuccess
}

func ClearTextEntry(fieldOne: inout String, fieldTwo: inout String){
    fieldOne = ""
    fieldTwo = ""
}

func containsCharacters(entry: String) -> Bool {
    let regex = "(^[0-9]+$)"
    let testString = NSPredicate(format:"SELF MATCHES %@", regex)
    return testString.evaluate(with: entry)
}

struct ProfileView: View{
    
    @State var showMenu = false
    @State private var bigFontMode = bigFontBool
    @State private var lightMode = lightModeBool
    @State private var info = settingsInfo
    
    // Observed object models
    @ObservedObject public var viewModel = UserViewModel()
    @ObservedObject public var vehicleViewModel = VehicleViewModel()
    
    // User variables
    @State private var password : String = ""
    @State private var confirmPass : String = ""
    @State private var newEmail : String = ""
    @State private var currentEmail : String = ""
    @State private var newPhone : String = ""
    @State public var hiredCar = ""
    
    // Alert type variables
    @State public var changePasswordAlertBox : Bool = false
    @State public var changeEmailAlertBox : Bool = false
    @State public var changePhoneAlertBox : Bool = false
    @State private var hasTimeElapsed = false
    
    
    let profileImage = UIImage(named: "MyImage")
    
    var body: some View {
        
        let drag = DragGesture().onEnded {
            if $0.translation.height > -100 || $0.translation.width > -100 {
                withAnimation {
                    self.showMenu = true
                }
            }
            if $0.translation.height < -100 || $0.translation.width < -100 {
                withAnimation {
                    self.showMenu = false
                }
            }
        }
        
        if self.bigFontMode {
            titleFont = 22 * 1.5;
            bodyFont = 16 * 1.5;
            largeTitleFont = 34 * 1.5;
            listFrameHeight = 120;
            bigFontBool = true
        }
        
        if !self.bigFontMode {
            titleFont = 22;
            bodyFont = 16;
            largeTitleFont = 34;
            listFrameHeight = 60;
            bigFontBool = false
        }
        
        if self.lightMode {
            backgroundColour = Color(red: 0.97, green: 0.97, blue: 0.97, opacity: 0.93);
            aurizonTextWhite = Color(red: 0.235, green: 0.235, blue: 0.235);
            basicBG = backgroundColour;
            textColour = .black
            lightModeBool = true
        }
        
        if !self.lightMode {
            backgroundColour = Color(red: 0.235, green: 0.235, blue: 0.235, opacity: 0.93);
            aurizonTextWhite = Color(red: 0.78, green: 0.78, blue: 0.78);
            basicBG = Color(red: 0.125, green: 0.125, blue: 0.125);
            textColour = .white
            lightModeBool = false
        }
        
        return GeometryReader { geometry in
            
            ZStack {
                // title menu
                if self.showMenu {
                    TileMenuView()
                        .transition(.move(edge: .top))
                        .onAppear(){
                            self.changeEmailAlertBox = false
                            self.changePasswordAlertBox = false
                            self.changePhoneAlertBox = false
                    }
                }
                
                // Tutorial Popup Card
                if tutorialActive {
                    if self.info {
                        VStack {
                            Text("View personal and accessibility settings").font(.system(size: titleFont+2, weight: .semibold)).multilineTextAlignment(.center)
                            
                            Text("View or update profile information. accessibility features are also available, including larger text and a light theme. Currently hired vehicle registrations can also be viewed.").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                            
                            HStack {
                                Button(action: { self.info = false; settingsInfo = false; }) {
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
                    // Top Half of profile page
                    HStack {
                        VStack{
                            // User profile image, limited to either X or Y 300 unit constraints
                            RemoteImage(url: self.viewModel.currentUser.photo).aspectRatio(contentMode: .fit)
                        }.frame(width: 300, height: 300).padding(.leading, 50)
                        
                        Spacer()
                        
                        // User information container, aligned to left
                        VStack (alignment: .leading){
                            Text("Hello, \(self.viewModel.currentUser.displayName)").font(.system(size: largeTitleFont * 0.9)).foregroundColor(textColour).multilineTextAlignment(.center).padding(.bottom)
                            
                            Text("Employee ID: \(self.viewModel.currentUser.id)").foregroundColor(textColour).font(.system(size: titleFont)).padding(.bottom)
                            
                            Text("Email: \(self.viewModel.currentUser.email)").foregroundColor(textColour).font(.system(size: titleFont)).padding(.bottom)
                            
                            Text("Phone: \(self.viewModel.currentUser.phone)").foregroundColor(textColour).font(.system(size: titleFont)).padding(.bottom)
                            
                        }.frame(width: 400).padding(.trailing, 40)
                        
                        Spacer()
                        
                    }.frame(height: 400)
                    
                    
                    Divider().background(Color.gray).frame(width: UIScreen.main.bounds.width - 100)
                    
                    // Bottom Half of profile page
                    HStack {
                        VStack(alignment: .leading) {
                            // Toggle accessibility settings
                            Text("Accessibility Settings").font(.system(size: bodyFont + 10)).foregroundColor(textColour).multilineTextAlignment(.leading).padding(.top)
                            
                            Toggle(isOn: self.$bigFontMode) {
                                Text("Enlarged Font").foregroundColor(textColour).font(.system(size: titleFont))
                            }.frame(width: 250).padding(.leading).padding(.bottom)
                            
                            Toggle(isOn: self.$lightMode) {
                                Text("Light Mode").foregroundColor(textColour).font(.system(size: titleFont))
                            }.frame(width: 250).padding(.leading)
                            
                            .padding(.bottom, 60) // space between Accessibility settings and profile settings
                            
                            // Update user information
                            Text("Profile Settings").font(.system(size: bodyFont + 10)).foregroundColor(textColour).multilineTextAlignment(.leading).padding(.top).padding(.bottom)
                            Button(action: { withAnimation {
                                self.changePasswordAlertBox.toggle() }})
                            {
                                Text("Change Password").font(.system(size: titleFont))
                            }.padding(.leading).padding(.bottom)
                            
                            Button(action: { withAnimation {
                                self.changeEmailAlertBox.toggle() }})
                            {
                                Text("Change Email").font(.system(size: titleFont))
                            }.padding(.leading).padding(.bottom)
                            
                            Button(action: { withAnimation {
                                self.changePhoneAlertBox.toggle() }})
                            {
                                Text("Change Phone Number").font(.system(size: titleFont))
                            }.padding(.leading).padding(.bottom)
                                .onAppear(perform: self.delayText)
                            Spacer()
                        }.frame(width: geometry.size.width / 2)
                        
                        // Horizontal axis
                        HStack{
                            VStack(alignment: .leading) {
                                Text("Currently Hired Vehicles").underline().foregroundColor(textColour).font(.system(size: bodyFont + 10)).padding(.top).padding(.bottom)
                                Text(self.hasTimeElapsed ? "\(self.vehicleViewModel.currentlyHired)" : "Loading hired vehicles...").foregroundColor(textColour).font(.system(size: self.hasTimeElapsed ? largeTitleFont * 0.8 : titleFont )).padding(.leading)
                                    .onAppear(perform: self.delayText)
                                
                                // Push contents to top of frame
                                Spacer()
                            }
                            // Push contents along horizontal axis
                            Spacer()
                        }.frame(width: geometry.size.width / 2)
                    }

                    
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).padding(.top, 20)
                    .background(basicBG)
            }
            .passwordFieldAlert(isShowing: self.$changePasswordAlertBox, password: self.$password, confirmPass: self.$confirmPass, title: "Create New Password")
            .emailFieldAlert(isShowing: self.$changeEmailAlertBox, currentEmail: self.$currentEmail, newEmail: self.$newEmail, vehicleViewModel: self.vehicleViewModel, viewModel: self.viewModel, title: "Create New Email")
            .onAppear() { self.viewModel.fetchData() ; self.viewModel.fetchCurrentUser() }
            .phoneFieldAlert(isShowing: self.$changePhoneAlertBox, newPhone: self.$newPhone, viewModel: self.viewModel)
            .onAppear() { self.viewModel.fetchData() ; self.viewModel.fetchCurrentUser() }
            .gesture(drag)
        }
        
    }
    private func delayText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.vehicleViewModel.fetchHired(email: self.viewModel.currentUser.email)
            self.hasTimeElapsed = true
        }
    }
}

//MARK:- Change Password Functionality
struct PasswordChangeAlert<Presenting>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    @Binding var password: String
    @Binding var confirmPass : String
    let presenting: Presenting
    let title: String
    @State private var showPassword1 : Bool = false
    @State private var showPassword2 : Bool = false
    @State private var showPassAlert : Bool = false
    @State var activeAlert: ActiveAlert = .weakPassword
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(self.isShowing)
                VStack {
                    Text("Change Password").font(.system(size: bodyFont)).foregroundColor(.black).bold()
                    // new password text field
                    Group{
                        HStack {
                            if self.showPassword1 {
                                TextField("New Password",
                                          text: self.$password)
                            } else {
                                SecureField("New Password",
                                            text: self.$password)
                            }
                            Button(action: { self.showPassword1.toggle()}) {
                                Image(systemName: self.showPassword1 ? "eye.slash.fill" : "eye.fill").foregroundColor(.secondary)
                            }
                        }
                        
                        // confirm password text field
                        HStack {
                            if self.showPassword2 {
                                TextField("Confirm Password",
                                          text: self.$confirmPass)
                            } else {
                                SecureField("Confirm Password",
                                            text: self.$confirmPass)
                            }
                            
                            Button(action: { self.showPassword2.toggle()}) {
                                Image(systemName: self.showPassword2 ? "eye.slash.fill" : "eye.fill").foregroundColor(.secondary)
                            }
                        }
                    }
                    .background(Color.white)
                    .frame(width: deviceSize.size.width / 3, height: 30 )
                    VStack{
                        Divider().background(Color.gray)
                    }
                        
                    .frame(width: deviceSize.size.width / 3, height: 30 )
                    // submit passwords
                    Button(action: {
                        self.isShowing = false
                        self.hideKeyboard()
                        // check password is at least 6 chars long
                        if (self.password.count < 6){
                            print("Password must be at least 6 characters long")
                            self.activeAlert = .weakPassword
                            ClearTextEntry(fieldOne: &self.password, fieldTwo: &self.confirmPass)
                            self.showPassAlert = true
                        }
                            // check new password and confirm password fields match
                        else if (self.password == self.confirmPass){
                            Auth.auth().currentUser?.updatePassword(to: self.password) { (error) in
                                if (error == nil) {
                                    self.activeAlert = .passwordChangeSuccess
                                    ClearTextEntry(fieldOne: &self.password, fieldTwo: &self.confirmPass)
                                    self.showPassAlert = true
                                }
                            }}
                        else {
                            print("Passwords did not match")
                            self.activeAlert = .passwordMissMatch
                            ClearTextEntry(fieldOne: &self.password, fieldTwo: &self.confirmPass)
                            self.showPassAlert = true
                        }})
                    {
                        Text("Submit")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
                
                //MARK:- Profile Alerts
                .alert(isPresented: self.$showPassAlert) {
                    switch self.activeAlert {
                    case .weakPassword:
                        return Alert(title: Text("Password must be at least 6 characters long"), message: Text("Enter a stronger password"),
                                     dismissButton: .default(Text("Ok")))
                    case .passwordMissMatch:
                        return Alert(title: Text("Passwords do not match"), message: Text("Please try again"),
                                     dismissButton: .default(Text("Ok")))
                    case .passwordChangeSuccess:
                        return Alert(title: Text("Success"), message: Text("Your password has been changed"),
                                     dismissButton: .default(Text("Ok")))
                    case .emailChangeSuccess:
                        return Alert(title: Text("Email Changed Successfully"),
                                     dismissButton: .default(Text("Dismiss")))
                    case .invalidEmail:
                        return Alert(title: Text("Email Incorrect"), message: Text("Check email entry"),
                                     dismissButton: .default(Text("Ok")))
                    case .wrongEmail:
                        return Alert(title: Text("Email Incorrect"), message: Text("You must first enter your current email"),
                                     dismissButton: .default(Text("Ok")))
                    case .phoneChangeSuccess:
                        return Alert(title: Text("Phone Number Changed Successfully"), dismissButton: .default(Text("Ok")))
                    case .mustReturnVehicle:
                        return Alert(title: Text("You Have a Vehicle on Hire"), message: Text("Please return vehicle before changing your email"), dismissButton: .default(Text("Ok")))
                    }}}}}

// MARK:- Change Email Functionality
struct EmailChangeAlert<Presenting>: View where Presenting: View {
    
    // Binding variables
    @Binding var isShowing: Bool
    @Binding var currentEmail : String
    @Binding var newEmail : String
    let presenting: Presenting
    let title: String
    @ObservedObject public var viewModel : UserViewModel
    @ObservedObject public var vehicleViewModel : VehicleViewModel
    
    // Alert Variables
    @State private var showAlert : Bool = false
    @State var activeAlert: ActiveAlert = .weakPassword
    var db = Firestore.firestore()
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(self.isShowing)
                
                VStack {
                    Text("Change Email").font(.system(size: bodyFont)).foregroundColor(.black).bold()
                    
                    Group {
                        TextField("Current Email",
                                  text: self.$currentEmail).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).disableAutocorrection(true)
                            .id(self.isShowing)
                            .font(.system(size: bodyFont))
                            .frame(width: deviceSize.size.width / 3, height: 50 )
                        
                        TextField("New Email",
                                  text: self.$newEmail).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).disableAutocorrection(true)
                            .id(self.isShowing)
                            .font(.system(size: bodyFont))
                            .frame(width: deviceSize.size.width / 3, height: 50 )
                    }
                    .background(Color.white)
                    .frame(width: deviceSize.size.width / 3, height: 30 )
                    VStack {
                        Divider().background(Color.gray)
                    }
                    .frame(width: deviceSize.size.width / 3, height: 30 )
                    
                    // submit email
                    Button(action: {
                        self.vehicleViewModel.fetchHired(email: self.viewModel.currentUser.email)
                        self.isShowing = false
                        self.hideKeyboard()
                        
                        // check email legitimacy
                        if (!isValid(email: self.newEmail)){
                            print("Incorrectly formatted email")
                            self.activeAlert = .invalidEmail
                            self.newEmail = ""
                            self.showAlert = true
                        }
                            
                            // check current email entry is current email and user does not have any cars hired
                        else if (self.currentEmail == self.viewModel.currentUser.email
                            && self.vehicleViewModel.currentlyHired == "No cars hired"){
                            print("viewModel: \(self.viewModel.currentUser.email)")
                            print(self.currentEmail)
                            print("allow email change")
                            Auth.auth().currentUser?.updateEmail(to: self.newEmail) { (error) in
                                // successfully found user
                                if (error == nil) {
                                    self.viewModel.currentUser.email = self.newEmail
                                    self.db.collection("users").document(self.viewModel.currentUser.id).setData([ "email" : self.newEmail ], merge: true)
                                    self.activeAlert = .emailChangeSuccess
                                    self.showAlert = true
                                    CurrentUser.user = self.newEmail // update profile view with new email
                                }
                                print(error as Any)
                            }}
                            // check if user has any cars on hire
                        else if(self.vehicleViewModel.currentlyHired != "No cars hired") {
                            self.activeAlert = .mustReturnVehicle
                            self.showAlert = true
                            print("you have cars on hire: \(self.vehicleViewModel.currentlyHired)")
                        }
                        else {
                            print("Current email is incorrect")
                            self.activeAlert = .wrongEmail
                            ClearTextEntry(fieldOne: &self.currentEmail, fieldTwo: &self.newEmail)
                            self.showAlert = true
                        }
                    })
                    {
                        Text("Submit")
                    }
                }
                    
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 10)
                .opacity(self.isShowing ? 1 : 0)
                    
                    // MARK:- Profile Alerts
                    .alert(isPresented: self.$showAlert) {
                        switch self.activeAlert {
                        case .weakPassword:
                            return Alert(title: Text("Enter a Stronger Password"), message: Text("Password must be at least six characters long"),
                                         dismissButton: .default(Text("Ok")))
                        case .passwordMissMatch:
                            return Alert(title: Text("Passwords Do Not Match"), message: Text("Please try again"),
                                         dismissButton: .default(Text("Ok")))
                        case .passwordChangeSuccess:
                            return Alert(title: Text("Success"), message: Text("Your password has been changed"),
                                         dismissButton: .default(Text("Ok")))
                        case .emailChangeSuccess:
                            return Alert(title: Text("Email Changed Successfully"),
                                         dismissButton: .default(Text("Dismiss")))
                        case .invalidEmail:
                            return Alert(title: Text("Email Incorrect"), message: Text("Check email entry"),
                                         dismissButton: .default(Text("Ok")))
                        case .wrongEmail:
                            return Alert(title: Text("Email Incorrect"), message: Text("You must first enter your current email: \(self.viewModel.currentUser.email)"),
                                         dismissButton: .default(Text("Ok")))
                        case .phoneChangeSuccess:
                            return Alert(title: Text("Phone Number Changed Successfully"), dismissButton: .default(Text("Ok")))
                        case .mustReturnVehicle:
                            return Alert(title: Text("You Have a Vehicle on Hire"), message: Text("Please return vehicle before changing your email"), dismissButton: .default(Text("Ok")))
                        }
                }}
        }}
}

//MARK:- Change Phone Number Functionality
struct PhoneChangeAlert<Presenting>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    @Binding var newPhone : String
    let presenting: Presenting
    //let title: String
    @ObservedObject public var viewModel : UserViewModel
    @State private var showAlert : Bool = false
    @State var activeAlert: ActiveAlert = .weakPassword
    var db = Firestore.firestore()
    @State var containsChars : Bool = false
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(self.isShowing)
                VStack {
                    Text("Change Phone Number").font(.system(size: bodyFont )).foregroundColor(.black).bold()
                    Group {
                        TextField("New Phone number",
                                  text: self.$newPhone).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/).disableAutocorrection(true)
                            .id(self.isShowing)
                            .font(.system(size: bodyFont))
                            .frame(width: deviceSize.size.width / 3)
                    }
                    .background(Color.white)
                    .frame(width: deviceSize.size.width / 3)
                    VStack {
                        Divider().background(Color.gray)
                    }
                    .frame(width: deviceSize.size.width / 3)
                    
                    // submit email
                    Button(action: {
                        
                        self.isShowing = false
                        self.hideKeyboard()
                        
                        // check phone number has no characters
                        if (containsCharacters(entry: self.newPhone)){
                            self.db.collection("users").document(self.viewModel.currentUser.id).setData([ "phone" : self.newPhone ], merge: true)
                            self.activeAlert = .phoneChangeSuccess
                            self.viewModel.currentUser.phone = self.newPhone
                            self.showAlert = true
                        }
                    })
                    {
                        Text("Submit")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 10)
                .opacity(self.isShowing ? 1 : 0)
                    // MARK:- Profile Alerts
                    .alert(isPresented: self.$showAlert) {
                        switch self.activeAlert {
                        case .weakPassword:
                            return Alert(title: Text("Enter a Stronger Password"), message: Text("Password must be at least six characters long"),
                                         dismissButton: .default(Text("Ok")))
                        case .passwordMissMatch:
                            return Alert(title: Text("Passwords Do Not Match"), message: Text("Please try again"),
                                         dismissButton: .default(Text("Ok")))
                        case .passwordChangeSuccess:
                            return Alert(title: Text("Success"), message: Text("Your password has been changed"),
                                         dismissButton: .default(Text("Ok")))
                        case .emailChangeSuccess:
                            return Alert(title: Text("Email Changed Successfully"),
                                         dismissButton: .default(Text("Dismiss")))
                        case .invalidEmail:
                            return Alert(title: Text("Email Incorrect"), message: Text("Check email entry"),
                                         dismissButton: .default(Text("Ok")))
                        case .wrongEmail:
                            return Alert(title: Text("Email Incorrect"), message: Text("You must first enter your current email: \(self.viewModel.currentUser.email)"),
                                         dismissButton: .default(Text("Ok")))
                        case .phoneChangeSuccess:
                            return Alert(title: Text("Phone Number Changed Successfully"), message: Text("You can now be contacted on \(self.newPhone)"), dismissButton: .default(Text("Ok")))
                        case .mustReturnVehicle:
                            return Alert(title: Text("You Have a Vehicle on Hire"), message: Text("Please return vehicle before changing your email"), dismissButton: .default(Text("Ok")))
                        }
                }}
        }}
}

extension View {
    func passwordFieldAlert(isShowing: Binding<Bool>,
                            password: Binding<String>,
                            confirmPass: Binding<String>,
                            title: String) -> some View {
        PasswordChangeAlert(isShowing: isShowing,
                            password: password,
                            confirmPass: confirmPass,
                            presenting: self,
                            title: title)
    }
    
    func emailFieldAlert(isShowing: Binding<Bool>,
                         currentEmail: Binding<String>,
                         newEmail: Binding<String>,
                         vehicleViewModel: VehicleViewModel,
                         viewModel: UserViewModel,
                         title: String) -> some View {
        EmailChangeAlert(isShowing: isShowing,
                         currentEmail: currentEmail,
                         newEmail: newEmail,
                         presenting: self,
                         title: title,
                         viewModel: viewModel, vehicleViewModel: vehicleViewModel)
        
    }
    func phoneFieldAlert(isShowing: Binding<Bool>,
                         newPhone: Binding<String>,
                         viewModel: UserViewModel) -> some View {
        PhoneChangeAlert(isShowing: isShowing,
                         newPhone: newPhone,
                         presenting: self,
                         viewModel: viewModel)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
