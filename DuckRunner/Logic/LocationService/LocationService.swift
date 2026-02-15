//
//  LocationService.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Combine
import MapKit

final class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {
    public let location: PassthroughSubject<CLLocation, Never> = .init()
    private let locationManager: CLLocationManager

    // Main initializer for use in app
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
    }

    // Testing initializer for injecting a mock
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location.send(location)
        }
    }
}
