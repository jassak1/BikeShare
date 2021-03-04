//
//  MapView.swift
//  BikemapAJ
//
//  Created by jassak on 10/02/2021.
//  Copyright © 2021 jassak1. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var location:Location
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: location.latitude, longitude: location.longitude)
        let span = MKCoordinateSpan(latitudeDelta: location.mapDelta, longitudeDelta: location.mapDelta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        
        uiView.removeAnnotations(uiView.annotations)    //delete all previous annotations with every update (before adding a new one)
        let marker=MKPointAnnotation()
        marker.coordinate=coordinate
        marker.title=location.title
        uiView.addAnnotation(marker)
    }
}
