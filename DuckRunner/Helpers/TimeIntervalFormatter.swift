//
//  TimeIntervalFormatter.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import Foundation

/// Formatter to display human readable time interval
let TimeIntervalFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = .dropAll
    return formatter
}()
