//
//  ReplayTrack.swift
//  DuckRunner
//
//  Created by vladukha on 26.02.2026.
//


import SwiftUI
import MapKit

extension MapContents {
    /// Track polyline with accent colored track
    @MapContentBuilder
    static public func replayTrack(_ track: Track) -> some MapContent {
        MapPolyline(coordinates: track.points.map({$0.position}),
                    contourStyle: .straight)
        .stroke(.cyan,
                style: .init(lineWidth: 4,
                             lineCap: .round,
                             lineJoin: .round))
    }
}

#Preview {
    Map() {
        MapContents.replayTrack(.filledTrack)
    }
}
