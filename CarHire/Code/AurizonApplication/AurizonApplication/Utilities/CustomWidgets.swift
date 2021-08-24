//  Created by QFOUR DEVELOPMENT on 14/8/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI


struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct EmailChallenge: View {
    
    let placeholder: String
    let iconName: String
    let text: Binding<String>
    let keyboardType: UIKeyboardType
    let isValid: (String) -> Bool
    
    init(placeholder: String,
         iconName: String,
         text: Binding<String>,
         keyboardType: UIKeyboardType = UIKeyboardType.default,
         isValid: @escaping (String)-> Bool = { _ in true}) {
        
        self.placeholder = placeholder
        self.iconName = iconName
        self.text = text
        self.keyboardType = keyboardType
        self.isValid = isValid
    }
    
    var showsError: Bool {
        if text.wrappedValue.isEmpty {
            return false
        } else {
            return !isValid(text.wrappedValue)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CustomTextField(
                    placeholder: Text(placeholder).foregroundColor(.gray),
                    text: text
                )
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.gray)
                    .foregroundColor(showsError ? .red : Color(red: 189 / 255, green: 204 / 255, blue: 215 / 255))
            }
            Rectangle()
                .frame(height: 2)
                .foregroundColor(showsError ? .red : Color(red: 189 / 255, green: 204 / 255, blue: 215 / 255))
        }
    }
}


struct TutorialFlow: View {
    
    @State private var selectPage: Int?
    @State private var close : Int?
    @State var animateExit1 = false
    @State var animateExit2 = false
    @State var animateNav = false
    
    var body: some View {
        VStack() {
            
            Spacer()
            
            ZStack {
                HStack {
                    Spacer()
                    ZStack {
                        
                        if exitBool {
                            if tutorialPageIndex == 1 {
                            Rectangle().fill(aurizonRed.opacity(0.45)).frame(width: 48, height: 48).cornerRadius(7.5).scaleEffect(self.animateExit1 ? 1 : 1.25).onAppear { self.animateExit1.toggle() }.animation(Animation.easeInOut(duration: 1.25).repeatForever(autoreverses: true))
                            
                            Rectangle().fill(aurizonRed.opacity(0.25)).frame(width: 48, height: 48).cornerRadius(7.5).scaleEffect(self.animateExit2 ? 1 : 1.5).onAppear { self.animateExit2.toggle() }.animation(Animation.easeInOut(duration: 1.25).repeatForever(autoreverses: true))
                            }
                        }
                        
                        NavigationLink(destination: getDestination(indexValue: 8)
                            .navigationBarHidden(true).navigationBarTitle(""), tag: 8, selection: $close) {
                                
                                // Nagivation to menu page
                                Button(action: {
                                    self.close = 8
                                    self.selectPage = nil
                                    tutorialActive = false
                                    exitBool = false
                                    tutAcpt = false
                                    tutStrt = false
                                    swpAnim = false
                                    cameraInfo = false
                                    hireInfo = false
                                    overlayInfo = false
                                    menuInfo = false
                                    feedbackInfo = false
                                    listInfo = false
                                    tutorialPageIndex = 1
                                }) {
                                    Image(systemName: "xmark.square.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 48, height: 48)
                                        .foregroundColor(aurizonRed)
                                }
                                
                        }
                    }
                }.padding(.trailing, 50).zIndex(10)
                
                HStack {
                    // Instructions to navigate
                    Text("Navigate Between Pages Using Arrows").font(.system(size: 24, weight: .semibold)).foregroundColor(.white).multilineTextAlignment(.center)
                }
                .frame(width: 450, height: 64)
                .background(aurizonGreyOPC93)
                .border(basicBG)
                .shadow(radius: 15)
                .zIndex(8)
            }
            
            // Unique spacer to push widgets to edges of screen
            Spacer().frame(maxHeight: UIScreen.main.bounds.height * 8 / 10)
            
            ZStack {
                if navBool {
                    if tutorialPageIndex == 1 {
                    Rectangle().fill(aurizonBlue.opacity(0.50)).frame(width: 272, height: 80).cornerRadius(5).scaleEffect(self.animateNav ? 1 : 1.25).onAppear { self.animateNav.toggle() }.animation(Animation.easeInOut(duration: 1.25).repeatForever(autoreverses: true))
                    }
                }
                HStack {
                    // Navigation to previous page
                    Button(action: { if tutorialPageIndex > 1 {
                        tutorialPageIndex -= 1
                        self.selectPage = tutorialPageIndex
                            if Registration.currentRego != "" { Registration.currentRego = "" } } } ) {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color.white)
                    }
                    Spacer()
                    // Creates progress tracking circles
                    ForEach(0 ..< numPages) {value in
                        if value == tutorialPageIndex-1 {
                            Image(systemName: "\(value + 1).circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color.white)
                        } else {
                            Image(systemName: "\(value + 1).circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color.white)
                        }
                    }
                    Spacer()
                    // Navigation wrapper that initiates functioning navigation
                    NavigationLink(destination: getDestination(indexValue: tutorialPageIndex)
                        .navigationBarHidden(true).navigationBarTitle(""), tag: tutorialPageIndex, selection: $selectPage) {
                            // Nagivation to next page
                            Button(action: { if tutorialPageIndex < numPages {
                                tutorialPageIndex += 1
                                self.selectPage = tutorialPageIndex
                                    if Registration.currentRego != "" { Registration.currentRego = "" } } } ) {
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(Color.white)
                            }
                            
                    }
                }
                .padding()
                .frame(width: 256, height: 64)
                .background(RoundedRectangle(cornerRadius: 5)
                .foregroundColor(aurizonBlue))
            }
            Spacer()
        }
    }
}


struct SearchChallenge: View {
    
    let placeholder: String
    let iconName: String
    let inversed: Bool
    let text: Binding<String>
    let keyboardType: UIKeyboardType
    //    let actionMethod: Method
    
    init(placeholder: String,
         iconName: String,
         text: Binding<String>,
         keyboardType: UIKeyboardType = UIKeyboardType.default,
         inversed: Bool
    /*actionMethod: Method*/) {
        
        self.placeholder = placeholder
        self.iconName = iconName
        self.inversed = inversed
        self.text = text
        self.keyboardType = keyboardType
        //        self.actionMethod = actionMethod
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CustomTextField(
                    placeholder: Text(placeholder).foregroundColor(inversed ? .white : .gray),
                    text: text
                )
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                //                    Button(action: { actionMethod } ) {
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor((inversed ? .white : .gray))
                //                    }
            }
            Rectangle().frame(height: 2).foregroundColor((inversed ? .white : .gray))
        }
    }
}




// Previews of widgets under different circumstances
struct Email_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmailChallenge(
                placeholder: "test@email.com",
                iconName: "envelope.fill",
                text: .constant(""))
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
            
            EmailChallenge(
                placeholder: "test@email.com",
                iconName: "envelope.fill",
                text: .constant("success@email.com"))
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
            
            EmailChallenge(
                placeholder: "test@email.com",
                iconName: "envelope.fill",
                text: .constant("failedemail.com"),
                isValid: { _ in false })
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchChallenge(
                placeholder: "Search",
                iconName: "magnifyingglass",
                text: .constant(""),
                inversed: false)
                //                actionMethod: psuedoMethod())
                .padding()
                .previewLayout(.fixed(width: 400, height: 50))
            
            
            SearchChallenge(
                placeholder: "Search",
                iconName: "magnifyingglass",
                text: .constant(""),
                inversed: true)
                //                actionMethod: psuedoMethod())
                .padding()
                .previewLayout(.fixed(width: 400, height: 50))
                .background(Color.gray)
            
            SearchChallenge(
                placeholder: "Search",
                iconName: "magnifyingglass",
                text: .constant("Completed Search"),
                inversed: true)
                //                actionMethod: psuedoMethod())
                .padding()
                .previewLayout(.fixed(width: 400, height: 50))
            
            SearchChallenge(
                placeholder: "Search",
                iconName: "magnifyingglass",
                text: .constant("Completed Search"),
                inversed: true)
                //                actionMethod: psuedoMethod())
                .padding()
                .previewLayout(.fixed(width: 400, height: 50))
                .background(Color.gray)
        }
    }
}

struct Tutorial_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            TutorialFlow().previewLayout(.fixed(width: 750, height: 300))
        }
    }
}
