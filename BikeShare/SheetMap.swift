//
//  SheetMap.swift
//  BikemapAJ
//
//  Created by jassak on 10/02/2021.
//  Copyright © 2021 jassak1. All rights reserved.
//

import SwiftUI
import MapKit
struct SheetMap: View {
    @ObservedObject var location:Location
    @Environment(\.presentationMode) var sheetActive
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action:{
                    sheetActive.wrappedValue.dismiss()
                })
                {
                    Image(systemName: "chevron.compact.down")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.medium))
                        .padding()
                }
                Text(location.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                MapView(location: location)
                    .cornerRadius(25)
                    .padding()
            }
        }
    }
}
