//
//  DistanceConverter.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Foundation
import CoreLocation

/// Utility for converting distance between different measurement units (e.g., meters to kilometers).
struct DistanceConverter {
    /// The distance value, stored as a measurement in meters.
    private let distance: Measurement<UnitLength>
    
    /// Initializes the converter with a distance (in meters).
    init(distance: CLLocationDistance) {
        self.distance = Measurement(value: distance, unit: UnitLength.meters)
    }
    
    /// Returns the distance converted to the specified length unit.
    func getDistance(_ lengthMeasurement: UnitLength) -> Double {
        let distanceConverted = distance.converted(to: lengthMeasurement)
        return distanceConverted.value
    }
}

