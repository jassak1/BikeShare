//
//  Stations.swift
//  BikemapAJ
//
//  Created by jassak on 10/02/2021.
//  Copyright © 2021 jassak1. All rights reserved.
//

import SwiftUI
import CoreLocation
import SwiftUIRefresh

struct City:Codable {
    var network:Network
    
    struct Network: Codable {
        var stations: [Stations]
    }
    
    struct Stations: Identifiable,Codable {
        var id:UUID{
            return UUID()
        }
        var empty_slots:Int?
        var actual_slots:String{
            empty_slots == nil ? "NA" : String(empty_slots ?? 0)
        }
        var name:String
        var free_bikes:Int
        var latitude:Double
        var longitude:Double
        var extra:Extra
    }
    
    struct Extra:Codable{
        var description:String?
    }
}

struct Stations: View {
    @State var showAlert=false
    @ObservedObject var mylocation=MyLocation()
    @State private var results = [City.Stations]()
    @ObservedObject var location:Location
    @State var showSheet=false
    @State var isrefresh=false
    var body: some View {
        NavigationView{
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    List{
                        ForEach(results){ item in
                            HStack {
                                Image(decorative: (item.free_bikes==0) ? "nonavailable" : "available")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing)
                                VStack(alignment: .leading){
                                    Text("\(item.name)")
                                        .fontWeight(.bold)
                                    Text("Description: \(item.extra.description ?? "NA")")
                                    Text("Available slots: \(item.actual_slots)")
                                    Text("Available bikes: \(item.free_bikes)")
                                }
                                Spacer()
                                Button(action:{
                                    location.latitude=item.latitude
                                    location.longitude=item.longitude
                                    location.title=item.name
                                    location.mapDelta=0.004
                                    self.showSheet=true
                                })
                                {
                                    Image(systemName: "mappin.and.ellipse")
                                        .padding(.trailing,5)
                                }
                                .sheet(isPresented: $showSheet, content: {
                                    SheetMap(location: location)
                                })
                            }
                            .listRowBackground(Color.black)
                            .foregroundColor(.white)
                        }
                    }
                    .padding(.top,1)
                    .listStyle(GroupedListStyle())
                    .pullToRefresh(isShowing: $isrefresh, onRefresh: {
                        loadData(){result in
                            switch result{
                            case .success(let message):
                                results=message
                            case .failure(let failure):
                                showAlert=true
                                switch failure {
                                case .DataFail:
                                    print("No Data received. Check URL address.")
                                case .DecoderFail:
                                    print("JSONDecoder failed. Please use print(error) inside decoding catch block for specific error description.")
                                case .ErrorFail:
                                    print("Invalid response from server. Please use localizedDescription for specific description.")
                                case .URLFail:
                                    print("Invalid URL.")
                                case .ResponseFail:
                                    print("HTTP Status Code not OK.")
                                }
                            }
                        }
                        isrefresh=false
                    })
                    .navigationBarHidden(true)
                }.alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Error!"), message: Text("There has been an issue while retrieving Your Data. Please try again later."), dismissButton: .default(Text("OK"),action: {
                        location.showStations=false
                    }))
                })
            }
        }
        .navigationBarTitle(Text("Available stations"),displayMode: .inline)
        .onAppear{
            loadData(){result in
                switch result{
                case .success(let message):
                    results=message
                case .failure(let failure):
                    showAlert=true
                    switch failure {
                    case .DataFail:
                        print("No Data received. Check URL address.")
                    case .DecoderFail:
                        print("JSONDecoder failed. Please use print(error) inside decoding catch block for specific error description.")
                    case .ErrorFail:
                        print("Invalid response from server. Please use localizedDescription for specific description.")
                    case .URLFail:
                        print("Invalid URL.")
                    case .ResponseFail:
                        print("HTTP Status Code not OK.")
                    }
                }
            }
        }
        .onDisappear(perform:location.swapLocation)
    }
    
    
    enum URLSessionError:Error{
        case URLFail
        case DataFail
        case ErrorFail
        case ResponseFail
        case DecoderFail
    }
    
    // retrieve JSON:
    func loadData(completion: @escaping (Result<[City.Stations],URLSessionError>)->Void) {
        guard let address = URL(string: location.url) else {
            completion(.failure(.URLFail))
            return
        }
        let request = URLRequest(url: address)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else{
                completion(.failure(.ErrorFail))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode==200 else{
                completion(.failure(.ResponseFail))
                return
            }
            guard let downloaded = data else {
                completion(.failure(.DataFail))
                return
            }
            do{
                let decodedResponse = try JSONDecoder().decode(City.self, from: downloaded)
                DispatchQueue.main.async {
                    guard let homelocation = mylocation.mycoordinates else{     //if location is acquired, sort array by nearest station first.....otherwise use station name for sorting
                        let subResults = decodedResponse.network.stations.sorted{$0.name<$1.name}
                        completion(.success(subResults))
                        return
                    }
                    let home = CLLocation(latitude: homelocation.latitude, longitude: homelocation.longitude)
                    mylocation.stopUpdating()
                    let subResults = decodedResponse.network.stations.sorted{distanceToStation(homeGPS: home, stationGPS: CLLocation(latitude: $0.latitude, longitude: $0.longitude))<distanceToStation(homeGPS: home, stationGPS: CLLocation(latitude: $1.latitude, longitude: $1.longitude))}
                    completion(.success(subResults))
                }
            }
            catch{
                completion(.failure(.DecoderFail))
            }
        }.resume()
    }
    
    func distanceToStation(homeGPS:CLLocation,stationGPS:CLLocation)->Double{
        return homeGPS.distance(from: stationGPS)  // result is in metres
    }
    
    //swap background in list, therefore clear UITABLEVIEW background on init:
    init(location:Location){
        UITableView.appearance().backgroundColor = .clear
        self.location=location
    }
}
