//
//  MyLocation.swift
//  BikemapAJ
//
//  Created by jassak on 10/02/2021.
//  Copyright © 2021 jassak1. All rights reserved.
//

import CoreLocation

class MyLocation: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    @Published var mycoordinates: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func stopUpdating(){        //in case we would like to stop retrieving location updates
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mycoordinates = locations.first?.coordinate
    }
}
