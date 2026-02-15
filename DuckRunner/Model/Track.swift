//
//  Track.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Foundation
import CoreLocation

struct Track: Identifiable {
    let id: UUID = .init()
    var points: [TrackPoint]
    let startDate: Date
    var stopDate: Date?
}

struct TrackPoint {
    let position: CLLocationCoordinate2D
    let speed: CLLocationSpeed
}




extension Array where Element == TrackPoint {
    /// Calculates the total distance of the path in meters.
    func totalDistance() -> CLLocationDistance {
        guard self.count > 1 else {
            return 0.0
        }

        var totalDistance: CLLocationDistance = 0.0
        
        for i in 0..<(self.count - 1) {
            let coordinate1 = self[i]
            let coordinate2 = self[i+1]
            
            // Convert CLLocationCoordinate2D to CLLocation to use the distance(from:) method
            let location1 = CLLocation(latitude: coordinate1.position.latitude,
                                       longitude: coordinate1.position.longitude)
            let location2 = CLLocation(latitude: coordinate2.position.latitude,
                                       longitude: coordinate2.position.longitude)
            
            totalDistance += location1.distance(from: location2)
        }
        
        return totalDistance
    }
    
    /// returns top speed in the array
    func topSpeed() -> CLLocationSpeed? {
        let topSpeed = self
            .max { ls, rs in
                ls.speed < rs.speed
            }
        return topSpeed?.speed
    }
}
