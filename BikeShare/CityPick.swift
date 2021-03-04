//
//  CityPick.swift
//  BikemapAJ
//
//  Created by jassak on 10/02/2021.
//  Copyright © 2021 jassak1. All rights reserved.
//

import SwiftUI

class Location:ObservableObject{
    @Published var showStations=false
    @Published var mapDelta=1.0
    @Published var title=String()
    @Published var longitude=Double()
    @Published var latitude=Double()
    @Published var url=String()
    @Published var element=Int(){
        didSet{
            UserDefaults.standard.setValue(element, forKey: "element")
            swapLocation()
        }
    }
    
    func swapLocation() {
        mapDelta=1.0
        switch element {
        case 0:
            title="Wien"
            latitude=48.19360
            longitude=16.369754
            url="http://api.citybik.es/v2/networks/citybike-wien?fields=stations"
        case 1:
            title="Bratislava"
            latitude=48.148680
            longitude=17.107018
            url="http://api.citybik.es/v2/networks/whitebikes?fields=stations"
        case 2:
            title="Nitra"
            latitude=48.306119
            longitude=18.076208
            url="http://api.citybik.es/v2/networks/arriva-nitra?fields=stations"
        case 3:
            title="Zilina"
            latitude=49.219282
            longitude=18.740761
            url="http://api.citybik.es/v2/networks/bikekia-zilina?fields=stations"
        default:
            title="Zilina"
            latitude=49.219282
            longitude=18.740761
            url="http://api.citybik.es/v2/networks/bikekia-zilina?fields=stations"
        }
    }
    
    init() {
        element=UserDefaults.standard.integer(forKey: "element")
    }
}


struct CityPick: View {
    let cities=["Wien","Bratislava","Nitra","Zilina"]
    let capacity=[120,102,9,20]    //number of stations in each city (could be replaced by count of array elements from network call and showing redacted in UI while loading, but to keep it clean i've choosen to list the count manually)
    @ObservedObject var location=Location()
    var body: some View {
        NavigationView {
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Select a city")
                    Picker("",selection: $location.element){
                        ForEach(0..<cities.count){
                            Text("\(cities[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    NavigationLink(
                        destination: Stations(location: location), isActive: $location.showStations,
                        label: {
                            HStack{
                                Rectangle()
                                    .fill(Color("background"))
                                    .frame(height:70)
                                    .shadow(color: .gray, radius: 3, x: 1, y: 1)
                                    .shadow(color: .black, radius: 2, x: -2, y: -2)
                                    .overlay(
                                        HStack{
                                            Image(decorative: cities[location.element])     // decorative keyword to turn off voiceover for image names
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(5)
                                            Text(cities[location.element])
                                                .font(.title)
                                                .fontWeight(.black)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                            Spacer()
                                            Rectangle()
                                                .fill(Color.orange)
                                                .frame(width: 70, height: 70)
                                                .overlay(
                                                    HStack{
                                                        VStack{
                                                            Text("\(capacity[location.element])")
                                                                .fontWeight(.black)
                                                            Text("stations")
                                                                .font(.caption2)
                                                                .fontWeight(.bold)
                                                        }
                                                        Image(systemName: "chevron.right")
                                                    }
                                                    .foregroundColor(.white)
                                                )
                                        }
                                        
                                    )
                            }
                        })
                    
                    MapView(location: location)
                        .cornerRadius(20)
                        .padding()
                }
            }
            .navigationBarHidden(true) // inside bar hidden
        }
        .navigationBarHidden(true)  // outside bar hidden - received
    }
}
