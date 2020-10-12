//
//  CityPick.swift
//  BikeShare
//
//  Created by Kardan on 07/10/2020.
//

import SwiftUI

class LongLat:ObservableObject{
    @Published var longitude=Double()
    @Published var latitude=Double()
    @Published var address=String()
    @Published var arrvalue=Int(){
        didSet{
            UserDefaults.standard.setValue(arrvalue, forKey: "arvv")
            swapLocation()
        }
    }
    
    func swapLocation() {
        switch arrvalue {
        case 0:
            longitude=48.148680
            latitude=17.107018
            address="http://api.citybik.es/v2/networks/whitebikes?fields=stations"
        case 1:
            longitude=48.306119
            latitude=18.076208
            address="http://api.citybik.es/v2/networks/arriva-nitra?fields=stations"
        case 2:
            longitude=49.219282
            latitude=18.740761
            address="http://api.citybik.es/v2/networks/bikekia-zilina?fields=stations"
        case 3:
            longitude=48.991844
            latitude=21.241220
            address="http://api.citybik.es/v2/networks/bicyklezadobreskutky?fields=stations"
        default:
            longitude=49.219282
            latitude=18.740761
            address="http://api.citybik.es/v2/networks/bikekia-zilina?fields=stations"
        }
    }
    
    init() {
        arrvalue=UserDefaults.standard.integer(forKey: "arvv")
    }
}


struct CityPick: View {
    let cities=["Bratislava","Nitra","Zilina","Presov"]
    let stationm=[99,9,20,6]
    @ObservedObject var longila=LongLat()
    var body: some View {
        NavigationView {
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    Text("Select a city")
                    Picker("",selection: $longila.arrvalue){
                        ForEach(0..<cities.count){
                            Text("\(cities[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    NavigationLink(
                        destination: Stations(urlad: longila),
                        label: {
                            HStack{
                                Rectangle()
                                    .fill(Color("background"))
                                    .frame(height:70)
                                    .shadow(color: .gray, radius: 3, x: 1, y: 1)
                                    .shadow(color: .black, radius: 2, x: -2, y: -2)
                                    .overlay(
                                        HStack{
                                            Image(decorative: cities[longila.arrvalue])
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(5)
                                            Text(cities[longila.arrvalue])
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
                                                            Text("\(stationm[longila.arrvalue])")
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
                    
                    MapView(getLoc: longila)
                        .cornerRadius(20)
                        .padding()
                }
            }
            .navigationBarHidden(true) // inside bar hidden
        }
        .navigationBarHidden(true)  // outside bar hiden - received
    }
    
}

struct CityPick_Previews: PreviewProvider {
    static var previews: some View {
        CityPick()
    }
}
