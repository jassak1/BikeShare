//
//  MapView.swift
//  BikeShare
//
//  Created by Kardan on 07/10/2020.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var getLoc:LongLat
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: getLoc.longitude, longitude: getLoc.latitude)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotationLocationds=[["title": "Bratislava", "latitude": 17.107018, "longitude": 48.148680],["title": "Nitra", "latitude": 18.076208, "longitude": 48.306119],["title": "Zilina", "latitude": 18.740761, "longitude": 49.219282],["title": "Presov", "latitude": 21.241220, "longitude": 48.991844]]
        for lokacia in annotationLocationds {
            let anotacie = MKPointAnnotation()
            anotacie.title=lokacia["title"] as? String
            anotacie.coordinate=CLLocationCoordinate2D(latitude: lokacia["longitude"] as! CLLocationDegrees, longitude: lokacia["latitude"] as! CLLocationDegrees )
            if (uiView.annotations.count<=4) {
                uiView.addAnnotation(anotacie)
            }
            else{
                return
            }
        }
    }
}
