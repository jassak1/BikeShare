//
//  Stations.swift
//  BikeShare
//
//  Created by Kardan on 08/10/2020.
//

import SwiftUI
import SwiftUIRefresh

class sendSheet:ObservableObject{
    @Published var longi:Double
    @Published var lati:Double
    @Published var title:String
    
    init() {
        longi=18.740761
        lati=49.219282
        title="ZA"
    }
    
}

struct Fhierarchy:Codable {       //reffering to object network
    var network:Shierarchy
}

struct Shierarchy: Codable {      //reffering to array stations
    var stations: [Thierarchy]
}

struct Thierarchy: Identifiable,Codable {      //reffering to properties
    var id=UUID()
    var name:String
    var free_bikes:Int
    var latitude:Double
    var longitude:Double
    
    enum CodingKeys:String,CodingKey {
        case name
        case free_bikes
        case latitude
        case longitude
    }
}


struct Stations: View {
    @ObservedObject var sheetvalues=sendSheet()
    @State private var results = [Thierarchy]()
    @State var isrefresh=false
    @ObservedObject var urlad:LongLat
    @State var isSheet=false
    var body: some View {
        NavigationView{
            ZStack {
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    List{
                        ForEach(results){ poloz in
                            HStack {
                                Image(decorative: (poloz.free_bikes==0) ? "nonavail" : "avail")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing)
                                VStack(alignment: .leading){
                                    Text("\(poloz.name)")
                                        .fontWeight(.bold)
                                    Text("Available bikes: \(poloz.free_bikes)")
                                }
                                Spacer()
                                Button(action:{
                                    sheetvalues.longi=poloz.longitude
                                    sheetvalues.lati=poloz.latitude
                                    sheetvalues.title=poloz.name
                                    self.isSheet=true
                                })
                                {
                                    Image(systemName: "mappin.and.ellipse")
                                        .padding(.trailing,5)
                                }
                                .sheet(isPresented: $isSheet, content: {
                                    SheetMap(gotlocation: sheetvalues)
                                })
                            }
                            .listRowBackground(Color.black)
                            .foregroundColor(.white)
                        }
                    }
                    .padding(.top,1)
                    .listStyle(GroupedListStyle())
                    .pullToRefresh(isShowing: $isrefresh, onRefresh: {
                        loadData()
                        isrefresh=false
                    })
                    .navigationBarHidden(true)
                }
            }
        }
        .navigationBarTitle(Text("Available stations"),displayMode: .inline)
        .onAppear(perform:loadData)
    }
    
    // retrieve JSON:
    func loadData() {
        guard let address = URL(string: urlad.address) else {
            return
        }
        let request = URLRequest(url: address)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let downloaded = data else {
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(Fhierarchy.self, from: downloaded) {
                DispatchQueue.main.async {
                    self.results = decodedResponse.network.stations
                }
            }
        }.resume()
    }
    
    /*
     // 2nd way to load json
     func nacitaj(){
     guard let adresa = URL(string: "http://api.citybik.es/v2/networks/bikekia-zilina?fields=stations") else {
     return
     }
     guard let retazec=try?Data(contentsOf: adresa) else{
     return
     }
     let decoder = JSONDecoder()
     if let jsonPetitions = try? decoder.decode(Fhierarchy.self, from: retazec) {
     results = jsonPetitions.network.stations
     }
     else {
     }
     }
     */
    
    //swap background on list, therefore clear UITABLEVIEW background on init:
    init(urlad:LongLat){
        UITableView.appearance().backgroundColor = .clear
        self.urlad=urlad
    }
}

struct Stations_Previews: PreviewProvider {
    static var previews: some View {
        Stations(urlad: LongLat())
    }
}

