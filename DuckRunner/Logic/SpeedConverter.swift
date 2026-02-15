//
//  SpeedConverter.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Foundation
import CoreLocation

struct SpeedConverter {
    /// Speed in m/s
    private let speed: Measurement<UnitSpeed>
    
    init(speed: CLLocationSpeed) {
        self.speed = Measurement(value: speed, unit: UnitSpeed.metersPerSecond)
    }
    
    func getSpeed(_ speedMeasurement: UnitSpeed) -> Int {
        let speedConverted = speed.converted(to: speedMeasurement)
        return Int(speedConverted.value.rounded())
    }
}
