//
//  ProfileView.swift
//  AurizonApplication
//
//  Created by QFOUR DEVELOPMENT on 26/7/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI

struct PlaceHolderView: View {

    @State var showMenu = false

    var body: some View {

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

        return NavigationView {

            GeometryReader { geometry in

                ZStack(alignment: .leading) {

                    PlaceHolder(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width : 0)
                        .disabled(self.showMenu ? true : false)

                    if self.showMenu {
                        TileMenuView()
                            .transition(.move(edge: .top))
                    }
                }
                .gesture(drag)
            }
            .navigationBarTitle("Scan Registration", displayMode: .inline)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PlaceHolder : View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
        
        Text("PlaceHolder")
        
    }
    
}

struct PlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceHolderView()
    }
}
