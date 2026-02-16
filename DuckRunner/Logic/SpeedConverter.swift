//
//  SpeedConverter.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Foundation
import CoreLocation

/// Utility for converting speed between units (e.g., meters per second to kilometers per hour).
struct SpeedConverter {
    /// The speed value, stored as a measurement in meters per second.
    private let speed: Measurement<UnitSpeed>
    
    /// Initializes the converter with a speed (in meters per second).
    init(speed: CLLocationSpeed) {
        self.speed = Measurement(value: speed, unit: UnitSpeed.metersPerSecond)
    }
    
    /// Returns the speed converted to the specified unit, as a rounded integer.
    func getSpeed(_ speedMeasurement: UnitSpeed) -> Int {
        let speedConverted = speed.converted(to: speedMeasurement)
        return Int(speedConverted.value.rounded())
    }
}

