//
//  MapLine.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import MapKit
import SwiftUI

/// Reusable line path
struct MapLine {
    
    private let points: [TrackPoint]
    init(points: [TrackPoint]) {
        self.points = points
    }
    func line() -> some MapContent {
        let sorted = points
            .sorted(by: {$0.date < $1.date})
            .map({ point in
            MKMapPoint(point.position)
        })
        return MapPolyline(points: sorted,
                    contourStyle: .straight)
        .stroke(Color.cyan,
                style: StrokeStyle(
                    lineWidth: 5,
                    lineCap: .round,
                    lineJoin: .round
                ))
    }
}
