//
//  SheetMap.swift
//  BikeShare
//
//  Created by Kardan on 11/10/2020.
//

import SwiftUI
import MapKit
struct SheetMap: View {
    @ObservedObject var gotlocation:sendSheet
    @Environment(\.presentationMode) var isactive
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action:{
                    isactive.wrappedValue.dismiss()
                })
                {
                    Image(systemName: "chevron.compact.down")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.medium))
                        .padding()
                }
                Text(gotlocation.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                ShView(gottenloc: gotlocation)
                    .cornerRadius(25)
                    .padding()
            }
        }
        
    }
}

struct SheetMap_Previews: PreviewProvider {
    static var previews: some View {
        SheetMap(gotlocation: sendSheet())
    }
}


struct ShView: UIViewRepresentable {
    @ObservedObject var gottenloc:sendSheet
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
        
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: gottenloc.lati, longitude: gottenloc.longi)
        let span = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let ann=MKPointAnnotation()
        ann.coordinate=coordinate
        ann.title=gottenloc.title
        uiView.addAnnotation(ann)
    }
}



