//
//  String Extension.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import Foundation

extension String {
    func toDate(format: String = "dd.MM.yyyy") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
    
    func toDate(style: DateFormatter.Style) -> Date {
        let formatter = DateFormatter()
        formatter.timeStyle = style
        return formatter.date(from: self) ?? Date()
    }
}
