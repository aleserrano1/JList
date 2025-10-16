//
//  LocationManager.swift
//  JList
//
//  Created by Josue Serrano Rodriguez on 12/12/24.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    
    // A closure that can be called every time the location updates.
    var onLocationUpdate: ((CLLocation) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.location = newLocation
            // Call the onLocationUpdate function when the location changes
            onLocationUpdate?(newLocation)  // Invoke the closure
        }
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}
