//  Created by QFOUR DEVELOPMENT on 24/7/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Firebase

enum ForgotPassAlerts {
    case checkEmail, userNotFound
}

struct LoginView: View {
    
    // global sizes
    static var iphoneWidth : CGFloat = 300
    static var ipadWidth : CGFloat = 520
    
    // Username and password parameters
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @State private var isLoginValid: Bool = false
    @State private var shouldShowLoginAlert: Bool = false
    @State private var alertMessage : String = ""
    @State private var isSuccessful : Bool = false
    @State private var isShowingAlert : Bool = false
    @State private var alertInput : String = ""
    
    // Skip logging in
    @State private var remainLogged: Bool = false // TO DO
    
    // runs different frame & camera parameters if deployed on iPad
    @State private var ipadRes : Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    func login() {
        Auth.auth().signIn(withEmail: username, password: password) {
            (result, error) in
            if error != nil {
                self.alertMessage = error?.localizedDescription ?? ""
                self.shouldShowLoginAlert = true
            }
            else {
                self.isLoginValid = true
            }
        }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            // Initialise Application navigation view - Allows navigation links to function
            NavigationView {
                
                // Initial VStack (Top Level Container (Contains all elements))
                VStack {
                    Spacer()
                    // logo/symbol implementation
                    Image("aurizon_white")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 10)
                        .padding(EdgeInsets(top: -46, leading: 0, bottom: -46, trailing: 0))
                    Spacer()
                    
                    // Instructions
                    Text("Please Enter Your Credentials")
                        .fontWeight(.semibold)
                        .foregroundColor(aurizonTextWhite)
                        .font(.system(size: 24))
                    
                    // Username and Password Container
                    VStack {
                        // Custom wiget used to house email with error visualiser
                        HStack {
                            EmailChallenge(
                                placeholder: "Email Address",
                                iconName: "envelope.fill",
                                text: self.$username,
                                keyboardType: .emailAddress,
                                isValid: isValid)
                                .padding()
                                .frame( width: self.ipadRes ? LoginView.ipadWidth - 160 : LoginView.iphoneWidth)
                                .background(Color.white)
                        }.background(Color.white)
                        
                        // Password field
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    
                                    if self.showPassword {
                                        TextField("Password",
                                                  text: self.$password)
                                    } else {
                                        SecureField("Password",
                                                    text: self.$password)
                                    }
                                    // Show password uncensored
                                    Button(action: { self.showPassword.toggle()}) {
                                        Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill").foregroundColor(.secondary)
                                    }
                                }
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(Color(red: 189 / 255, green: 204 / 255, blue: 215 / 255))
                                
                            }.padding()
                                .frame( width: self.ipadRes ? LoginView.ipadWidth - 160 : LoginView.iphoneWidth)
                                .background(Color.white)
                        }
                    }.padding()
                    
                    // Log In Button, links to next page if credentials are verified
                    NavigationLink( destination: ScanView().navigationBarHidden(true).navigationBarTitle(""), isActive: self.$isLoginValid){
                        Text("Log In")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? LoginView.ipadWidth - 160 : LoginView.iphoneWidth, height: 42.0 )
                            .background(RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(aurizonOrange))
                            .onTapGesture {
                                CurrentUser.user = self.username
                                self.login()
                        }
                    }
                    
                    Spacer().frame(height: 50)
                    
                    // Forgot password prompt to reset password
                    Button(action: {
                        withAnimation {
                            self.isShowingAlert.toggle()
                        }}){
                            Text("Forgot Password")
                    }
                    
                    Spacer()
                    // Alert popup prompts
                }.textFieldAlert(isShowing: self.$isShowingAlert, text: self.$alertInput, title: "Enter Email")
                    // gray login frame adjustments
                    .frame(width: UIScreen.main.bounds.width * 5 / 7, height: UIScreen.main.bounds.height * 5 / 7)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(aurizonGreyOPC93))
                    .keyboardResponsive()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0))
                    
                    // Ignores bleeding from device task bars
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .padding(.top, 64)
                    
                    // Create blurred background
                    .background(Image("TrackBG").resizable().scaledToFill().blur(radius:12))
                    
                    // Hide Navigation Whitespace
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                // assert alert message
            }.alert(isPresented: self.$shouldShowLoginAlert) {
                Alert(title: Text("\(self.alertMessage)"))
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// Regex validation for email address format, prompts error state
func isValid(email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
}

// Debug
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct KeyboardResponsiveModifier: ViewModifier {
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                    let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
                    self.offset = height - (bottomInset ?? 0)
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
                    self.offset = 0
                }
        }
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String
    @State private var activeAlert : ForgotPassAlerts = .userNotFound
    @State private var showAlert : Bool = false
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(self.isShowing)
                VStack {
                    Text("Reset Password").bold()
                    TextField("Enter Email", text: self.$text)
                        .lineLimit(1)
                        .id(self.isShowing)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .disableAutocorrection(true)
                    Divider().background(Color.gray)
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                                // send recovery email
                                Auth.auth().sendPasswordReset(withEmail: self.text){ (error) in
                                    // Email sent.
                                    if (error == nil){
                                        self.activeAlert = .checkEmail
                                        self.showAlert.toggle()
                                        
                                    }
                                        // user does not exist in DB
                                    else {
                                        self.activeAlert = .userNotFound
                                        self.showAlert.toggle()
                                        print (error as Any)
                                    }
                                } } } )
                        { Text("Submit") } }
                }
                .alert(isPresented: self.$showAlert) {
                    switch self.activeAlert {
                    case .checkEmail:
                        return Alert(title: Text("Account Found"), message: Text("Please check your email for an account recovery link"),
                                     dismissButton: .default(Text("Ok")))
                    case .userNotFound:
                        return Alert(title: Text("Email Not Found"), message: Text("There is no account associated with this email"),
                                     dismissButton: .default(Text("Ok")))
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .black, radius: 30)
                .opacity(self.isShowing ? 1 : 0)
                .frame(width: LoginView.ipadWidth - 100)
            }
        }
    }
}

extension View {
    func keyboardResponsive() -> ModifiedContent<Self, KeyboardResponsiveModifier> {
        return modifier(KeyboardResponsiveModifier())
    }
    
    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
    }
}
