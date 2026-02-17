//
//  SpeedUnit Extension.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import Foundation

/// Extension on `UnitSpeed` to provide a convenient way to convert a string name to a `UnitSpeed` enum value.
/// 
/// This extension allows parsing a string (e.g., "m/s", "km/h") and mapping it to the corresponding `UnitSpeed` enum.
/// It supports common speed units including meters per second, kilometers per hour, and miles per hour.
/// 
/// - Note: If the input string does not match any known unit, the default value `.kilometersPerHour` is returned.
extension UnitSpeed {
    
    /// Converts a string representation of a speed unit to its corresponding `UnitSpeed` enum value.
    /// 
    /// - Parameter name: A string representing the speed unit (e.g., "m/s", "km/h", "mph").
    /// - Returns: The corresponding `UnitSpeed` enum value.
    /// - Examples:
    ///     - "m/s" → .metersPerSecond
    ///     - "km/h" → .kilometersPerHour
    ///     - "mph" → .milesPerHour
    ///     - Any other string → .kilometersPerHour (default)
    ///
    /// Example:
    ///     UnitSpeed.byName("km/h") // returns .kilometersPerHour
    ///     UnitSpeed.byName("mph")  // returns .milesPerHour
    ///     UnitSpeed.byName("invalid") // returns .kilometersPerHour
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
