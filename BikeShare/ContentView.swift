//
//  ContentView.swift
//  BikeShare
//
//  Created by Kardan on 06/10/2020.
//

import SwiftUI
import SwiftUIRefresh




struct ContentView: View {
    @State var zobraz=false
    var body: some View {
        NavigationView {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                VStack {
                    Image(decorative: "bike")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .shadow(color: .black, radius: 7)
                        .padding(.top,50)
                    Spacer()
                    NavigationLink(
                        destination: CityPick(),
                        label: {
                            Text("Get started")
                                .foregroundColor(.white)
                                .padding()
                                .padding(.horizontal,30)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color("background"))
                                                .shadow(color: .white, radius: 1, x: 1, y: 1)
                                                .shadow(color: .black, radius: 1, x: -2, y: -2)
                                )
                                .padding(.bottom,100)
                        })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
