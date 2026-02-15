//
//  DistanceConverter.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Foundation
import CoreLocation

struct DistanceConverter {
    /// distance in meters
    private let distance: Measurement<UnitLength>
    
    init(distance: CLLocationDistance) {
        self.distance = Measurement(value: distance, unit: UnitLength.meters)
    }
    
    func getDistance(_ lengthMeasurement: UnitLength) -> Double {
        let distanceConverted = distance.converted(to: lengthMeasurement)
        return distanceConverted.value
    }
}
