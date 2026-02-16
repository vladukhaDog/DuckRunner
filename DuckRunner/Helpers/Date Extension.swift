//
//  Date Extension.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//


import Foundation

extension Date {
    
    public func toString(format: String = "dd.MM.YYYY") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    public func toString(style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
    
    func add(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self) ?? Date()
    }
}
