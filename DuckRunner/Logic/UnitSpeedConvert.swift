//
//  UnitSpeedConvert.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import Foundation


extension UnitSpeed {
    /// Returns UnitLength used in this UnitSpeed
    var unitLength: UnitLength {
        switch self {
        case .milesPerHour:
            return .miles
        case .metersPerSecond:
            return .meters
        case .kilometersPerHour:
            return .kilometers
        case .knots:
            return .nauticalMiles
        default:
            return .meters
        }
    }
}
