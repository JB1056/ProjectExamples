//  Created by QFOUR DEVELOPMENT on 8/9/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import Foundation

import SwiftUI

struct HireListView: View {
    
    // view menu boolean
    @State private var showMenu = false
    @State private var info = listInfo
    
    // CHevron status states
    @State private var ChevronArray = [false, false, false]
    
    // Ambient filtername variables title, call
    @State private var FilterArray = [["Location", "address"],
                                      ["Registration", "plate"],
                                      ["Status", "status"]]
    
    // Empty initial search state
    @State private var searchValue: String = ""
    
    @ObservedObject private var viewModel = VehicleViewModel()
    
    // Configure Table View Appearance
    init() {
        UITableView.appearance().separatorColor = UIColor.white
        UITableView.appearance().backgroundColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 0.1)
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().preservesSuperviewLayoutMargins = false
        UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        UITableViewCell.appearance().layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    var body: some View {
        
        // Asserts swipe navigation state
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
        
        return GeometryReader { geometry in
            ZStack {
                
                // Tutorial Popup Card
                if tutorialActive {
                    if self.info {
                        VStack {
                            Text("View all vehicle locations, registrations and hire status").font(.system(size: titleFont+6, weight: .semibold)).multilineTextAlignment(.center)
                            
                            Text("Cell interaction has been disabled during the tutorial").font(.system(size: bodyFont, weight: .semibold)).multilineTextAlignment(.center).padding()
                            
                            Text("This view shows all vehicles and their availability and location. Each category can be sorted by tapping the chevron. Vehicles can be hired or returned by selecting the corresponding row. Contact information can be viewed on already hired vehicles.").font(.system(size: bodyFont)).multilineTextAlignment(.center).padding()
                            
                            HStack {
                                Button(action: { self.info = false; listInfo = false; }) {
                                    Text("OK")
                                        .font(.system(size: bodyFont, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width / 4, height: 42.0 )
                                        .background(RoundedRectangle(cornerRadius: 40)
                                            .foregroundColor(aurizonOrange)).padding()
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width * 4 / 5, height: 450)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .zIndex(8)
                    }
                    // Initiate Tutorial Widget
                    TutorialFlow().zIndex(8)
                }
                
                
                VStack{
                    VStack {
                        // Search Bar UI
                        /*
                         HStack {
                         SearchChallenge(
                         placeholder: "Search",
                         iconName: "magnifyingglass",
                         text: self.$searchValue,
                         inversed: false)
                         .frame(width: 525).padding()
                         }.background(RoundedRectangle(cornerRadius: 15)
                         .foregroundColor(Color(red: 255, green: 255, blue: 255)))
                         .padding(.top, 25)
                         */
                        
                        // Table category titles and filters
                        HStack{
                            Spacer()
                            ForEach(0 ..< 3) {i in
                                Text(self.FilterArray[i][0]).bold()
                                    .foregroundColor(textColour)
                                    .font(.system(size: 24))
                                Button(action: {
                                    
                                    // Selects Category to Sort
                                    self.viewModel.category = self.FilterArray[i][1]
                                    
                                    // Checks and sets filtering in correct direction
                                    if self.ChevronArray[i] == true { self.viewModel.descending = true }
                                    else if self.ChevronArray[i] == false { self.viewModel.descending = false }
                                    self.viewModel.fetchData()
                                    self.ChevronArray[i].toggle()
                                    
                                    print( "sort by " + self.FilterArray[i][0] ) } ) {
                                        Image(systemName: self.ChevronArray[i] ? "chevron.up" : "chevron.down")
                                            .foregroundColor(textColour) }
                                Spacer()
                            }
                        }.frame(width: 600, height: 50).padding(.top, 15)
                        
                        List(self.viewModel.vehicles) { vehicle in
                            ListRow(vehicle: vehicle) }
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: 600, height: 700)
                    }
                }.background(backgroundColour).cornerRadius(25).padding(.top, 50)
                
                // calls tile menu if showMenu is triggered
                if self.showMenu { TileMenuView().transition(.move(edge: .top)) }
            }
                // Background configuration
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Image("TrackBG").resizable().scaledToFill().blur(radius:12))
                .edgesIgnoringSafeArea(.all)
                .gesture(drag)
        }
        .onAppear() {
            self.viewModel.fetchData()
        }
        .edgesIgnoringSafeArea(.all)
        
    }
    
}

struct ListHireView_Previews: PreviewProvider {
    static var previews: some View {
        HireListView()
    }
}
