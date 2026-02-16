//
//  SpeedUnit Extension.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import Foundation

extension UnitSpeed {
    static func byName(_ name: String) -> UnitSpeed {
        switch name {
        case "m/s":
            return .metersPerSecond
        case "km/h":
            return .kilometersPerHour
        case "mph":
            return .milesPerHour
        default:
            return .kilometersPerHour
        }
    }
}
