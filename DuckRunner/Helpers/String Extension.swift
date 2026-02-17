//
//  String Extension.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import Foundation

/// Extension on `String` to provide convenient date parsing functionality.
/// Allows conversion of a string representation of a date into a `Date` object
/// using various formatting patterns or time styles.
extension String {
    
    /// Converts a string to a `Date` using a specified date format pattern.
    /// 
    /// - Parameters:
    ///   - format: A string representing the date format pattern (e.g., "dd.MM.yyyy").
    ///             Default is "dd.MM.yyyy".
    /// - Returns: A `Date` object parsed from the string, or the current date if parsing fails.
    /// - Note: This method uses `DateFormatter` with the provided format string.
    ///         If the string cannot be parsed, it returns the current date.
    ///
    /// Example:
    ///     "01.03.2025".toDate(format: "dd.MM.yyyy") // returns a Date object for March 1, 2025
    func toDate(format: String = "dd.MM.yyyy") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}
