//  Created by QFOUR DEVELOPMENT on 14/8/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI

struct TileMenuView: View {
    
    private var padding : CGFloat = 15
    private var height = UIScreen.main.bounds.height
    private var width = UIScreen.main.bounds.width
    @State var info = menuInfo
    @State var logAlert = false
    
    var body: some View {
        
        ZStack {
            if tutorialActive {
                // Alert that signout is unavailable
                if self.logAlert {
                    VStack {
                        Text("Sign Out is not available during tutorial").font(.system(size: titleFont, weight: .semibold)).padding()
                        HStack {
                            Button(action: { self.logAlert = false; }) {
                                Text("OK")
                                    .font(.system(size: bodyFont, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                    .background(RoundedRectangle(cornerRadius: 40)
                                        .foregroundColor(aurizonOrange)).padding()
                            }
                        }
                    }.frame(width: UIScreen.main.bounds.width * 3 / 5, height: 150)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(radius: 10)
                        .zIndex(10)
                }
                
                // Tutorial Popup Card
                if self.info {
                    VStack {
                        Text("Navigate by tapping desired tile").font(.system(size: titleFont+6, weight: .semibold))
                        
                        Text("This is the central hub of the application, from here you can navigate to the desired feature. Simply tap the tile you wish to visit").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                        
                        HStack {
                            Button(action: { self.info = false; menuInfo = false; }) {
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
                        .zIndex(10)
                }
                // Initiate Tutorial Widget
                TutorialFlow().zIndex(8)
            }
            VStack() {
                // 1st row
                HStack {
                    NavigationLink (destination: HireView().environmentObject(showOverlay())
                        .navigationBarTitle("")
                        .navigationBarHidden(true)) {
                            VStack {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(aurizonOrange)
                                Text("Registration Search")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(textColour)
                                    .font(.system(size: titleFont, weight: .bold))
                            }
                            .frame(width: (width / 2 - padding), height: (height / 3.25 - padding))
                            .border(Color.gray)
                            .background(backgroundColour)
                    }.simultaneousGesture(TapGesture().onEnded {
                        if tutorialActive {
                            tutorialPageIndex = 3
                            print(tutorialPageIndex)
                        }
                    })
                    
                    NavigationLink (destination: HireListView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)) {
                            VStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .resizable()
                                    .frame(width: 60, height: 72)
                                    .foregroundColor(Color(red: 0.952, green: 0.368, blue: 0.07, opacity: 1.0))
                                Text("Availability List")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(textColour)
                                    .font(.system(size: titleFont, weight: .bold))
                            }
                            .frame(width: (width / 2 - padding), height: (height / 3.25 - padding))
                            .border(Color.gray)
                            .background(backgroundColour)
                    }.simultaneousGesture(TapGesture().onEnded {
                        if tutorialActive {
                            tutorialPageIndex = 6
                            print(tutorialPageIndex)
                        }
                    })
                }
                
                // 2nd row
                HStack {
                    NavigationLink (destination: ScanView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)) {
                            VStack {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .frame(width: 72, height: 60)
                                    .foregroundColor(Color(red: 0.952, green: 0.368, blue: 0.07, opacity: 1.0))
                                Text("Registration Scan")
                                    .foregroundColor(textColour)
                                    .font(.system(size: titleFont, weight: .bold))
                            }
                            .frame(width: (width / 2 - padding), height: (height / 3.25 - padding))
                            .border(Color.gray)
                            .background(backgroundColour)
                    }.simultaneousGesture(TapGesture().onEnded {
                        if tutorialActive {
                            tutorialPageIndex = 2
                            print(tutorialPageIndex)
                        }
                    })
                    
                    NavigationLink (destination: TutorialView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)) {
                            VStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color(red: 0.952, green: 0.368, blue: 0.07, opacity: 1.0))
                                Text("Tutorial Overview")
                                    .foregroundColor(textColour)
                                    .font(.system(size: titleFont, weight: .bold))
                            }
                            .frame(width: (width / 2 - padding), height: (height / 3.25 - padding))
                            .border(Color.gray)
                            .background(backgroundColour)
                    }.simultaneousGesture(TapGesture().onEnded {
                        if tutorialActive {
                            tutorialPageIndex = 1
                            print(tutorialPageIndex)
                        }
                    })
                    
                }
                
                // 3rd row
                HStack {
                    NavigationLink (destination: ProfileView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)) {
                            VStack {
                                Image(systemName: "gear")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color(red: 0.952, green: 0.368, blue: 0.07, opacity: 1.0))
                                Text("Profile & Settings")
                                    .foregroundColor(textColour)
                                    .font(.system(size: titleFont, weight: .bold))
                            }
                            .frame(width: (width / 2 - padding), height: (height / 3.25 - padding))
                            .border(Color.gray)
                            .background(backgroundColour)
                    }.simultaneousGesture(TapGesture().onEnded {
                        if tutorialActive {
                            tutorialPageIndex = 7
                            print(tutorialPageIndex)
                        }
                    })
                    
                    // Check if login is a psuedo button or functional for tutorial
                    if tutorialActive {
                        
                        Button(action: { self.logAlert = true; }) {
                            VStack {
                                Image(systemName: "nosign")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color(red: 0.952, green: 0.368, blue: 0.07, opacity: 1.0))
                                Text("Sign Out")
                                    .foregroundColor(fontColour)
                                    .font(.system(size: titleFont, weight: .bold))
                            }.frame(width: (width / 2 - padding), height: (height / 3.25 - padding))
                                .border(Color.gray)
                                .background(backgroundColour)
                        }
                        
                    } else {
                        NavigationLink (destination: LoginView()
                            .navigationBarTitle("")
                            .navigationBarHidden(true)) {
                                VStack {
                                    Image(systemName: "nosign")
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(Color(red: 0.952, green: 0.368, blue: 0.07, opacity: 1.0))
                                    Text("Sign Out")
                                        .foregroundColor(textColour)
                                        .font(.system(size: titleFont, weight: .bold))
                                }
                                .frame(width: (width / 2 - padding), height: (height / 3.25 - padding))
                                .border(Color.gray)
                                .background(backgroundColour)
                        }
                    }
                }
                
                // modifiers
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
            .background(
                Image("TrackBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill).blur(radius: 4)
                    .edgesIgnoringSafeArea(.all)
            )
                
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }.zIndex(10)
        
    }
}

struct TileMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TileMenuView()
    }
}
