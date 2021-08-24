//  Created by QFOUR DEVELOPMENT on 26/7/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI

struct TutorialView: View {
    
    @State var animateSwipe = false
    @State private var tutorialAccept = tutAcpt
    @State private var tutorialStart = tutStrt
    @State private var navigationAnimation = navAnim
    @State private var exitAnimation = extAnim
    @State private var swipeAnimation = swpAnim
    @State private var extBool = exitBool
    @State private var navigationBool = navBool
    @State var showMenu = false
    @State private var returnToMenu : Int?
    
    var body: some View {
        
        let drag = DragGesture().onEnded {
            if $0.translation.height > -100 {
                withAnimation {
                    self.showMenu = true
                    self.animateSwipe = false
                }
            }
            if $0.translation.height < -100 {
                withAnimation {
                    self.showMenu = false
                }
            }
        }
        
        return GeometryReader { geometry in
            
            ZStack {
                if !self.tutorialStart {
                    // Offer choice to accept or decline tutorial
                    if !self.tutorialAccept {
                        VStack {
                            Text("Welcome to the Tutorial").font(.system(size: titleFont+6, weight: .semibold))
                            Text("This is an overview of the application, you can quit at any time").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                            
                            HStack{
                                // Accept Tutorial button
                                Button(action: { self.tutorialAccept = true; tutAcpt = true  }) {
                                    Text("Begin Tutorial")
                                        .font(.system(size: bodyFont, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                        .background(RoundedRectangle(cornerRadius: 40)
                                            .foregroundColor(aurizonOrange)).padding(.trailing)
                                }
                                // Reject Tutorial and return to Menu
                                NavigationLink(destination: getDestination(indexValue: 8)
                                    .navigationBarHidden(true).navigationBarTitle(""), tag: 8, selection: self.$returnToMenu) {
                                        
                                        Button(action: {
                                            self.tutorialAccept = false
                                            tutAcpt = false
                                            tutorialActive = false
                                            self.returnToMenu = 8
                                        }) {
                                            Text("Return to Menu")
                                                .font(.system(size: bodyFont, weight: .semibold))
                                                .foregroundColor(.white)
                                                .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                                .background(RoundedRectangle(cornerRadius: 40)
                                                    .foregroundColor(aurizonOrange)).padding(.leading)
                                        }
                                }
                                
                                
                                
                            }
                        }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 200)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    } else {
                        VStack {
                            HStack {
                                Image(systemName: "arrow.up.arrow.down").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(aurizonGreyOPC93)
                                
                                Spacer()
                                VStack {
                                    Text("This application can be navigated by swiping up or down on the screen. Swiping down will show the navigation menu, swiping up will return you to the last page visited").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                                    
                                    // Initiate all tutorial variables
                                    Button(action: { self.tutorialStart = true; tutStrt = true; extAnim = true; self.exitAnimation = true; exitBool = true; self.extBool = true; cameraInfo = true; hireInfo = true; overlayInfo = true; feedbackInfo = true; menuInfo = true; listInfo = true; settingsInfo = true;
                                    }) {
                                        Text("Continue")
                                            .font(.system(size: bodyFont, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                            .background(RoundedRectangle(cornerRadius: 40)
                                                .foregroundColor(aurizonOrange)).padding()
                                    }
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 300)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    }
                } else {
                    
                    if self.tutorialStart && self.extBool && !self.navigationBool {
                        TutorialFlow()
                    }
                    
                    if self.tutorialStart && !self.extBool && self.navigationBool {
                        TutorialFlow()
                    }
                    
                    // Contains tutorial prompts and animation enablers
                    VStack {
                        if self.exitAnimation {
                            VStack {
                                Text("").font(.system(size: titleFont+6, weight: .semibold))
                                Text("You can quit the tutorial at any time by exiting with the button in the top right corner").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                                
                                HStack{
                                    Button(action: { extAnim = false; navAnim = true; self.navigationAnimation = true; self.exitAnimation = false; exitBool = false; self.extBool = false; self.navigationBool = true; navBool = true }) {
                                        Text("Continue")
                                            .font(.system(size: bodyFont, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                            .background(RoundedRectangle(cornerRadius: 40)
                                                .foregroundColor(aurizonOrange)).padding()
                                    }
                                }
                            }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 200)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                        }
                        
                        if self.navigationAnimation {
                            VStack {
                                Text("In addition to swiping, you may navigate to select pages using the navigator at the bottom of the screen").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                                
                                HStack{
                                    Button(action: { navAnim = false; swpAnim = true; self.navigationAnimation = false; self.swipeAnimation = true; self.navigationBool = false; navBool = false
                                        print(self.navigationBool)
                                        print(self.extBool)
                                        print(navBool)
                                        print(exitBool)
                                    }) {
                                        Text("Continue")
                                            .font(.system(size: bodyFont, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                            .background(RoundedRectangle(cornerRadius: 40)
                                                .foregroundColor(aurizonOrange)).padding()
                                    }
                                }
                            }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 200)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                        }
                        
                        // Visual Prompt to swiple down for unguided tutorial
                        if self.swipeAnimation {
                            ZStack {
                                Image(systemName: "arrow.down").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 256, height: 256)
                                    .foregroundColor(aurizonGreyOPC93)
                                
                                Circle().fill(aurizonGreyOPC93.opacity(0.50)).frame(width: 256, height: 256).cornerRadius(5).scaleEffect(self.animateSwipe ? 1.15 : 1.3).onAppear { self.animateSwipe.toggle() }.animation(Animation.easeInOut(duration: 1.75).repeatForever(autoreverses: true))
                                
                                TutorialFlow()
                                
                                if self.showMenu && self.tutorialAccept && self.tutorialStart {
                                    TileMenuView().transition(.move(edge: .top))
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(basicBG)
            .gesture(drag)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {tutorialActive = true}
    }
}

struct PlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
