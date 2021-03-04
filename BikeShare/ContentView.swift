//
//  ContentView.swift
//  BikemapAJ
//
//  Created by jassak on 10/02/2021.
//  Copyright © 2021 jassak1. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                VStack {
                    Image(decorative: "bike")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
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
