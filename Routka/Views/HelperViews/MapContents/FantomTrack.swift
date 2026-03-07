//
//  FantomTrack.swift
//  Routka
//
//  Created by vladukha on 26.02.2026.
//

import SwiftUI
import MapKit

extension MapContents {
    /// Track polyline with accent colored track
    @MapContentBuilder
    static public func fantomTrack(_ track: Track) -> some MapContent {
        Self.fantomTrack(track.points)
    }
    
    /// Track polyline with accent colored track
    @MapContentBuilder
    static public func fantomTrack(_ track: [TrackPoint]) -> some MapContent {
        MapPolyline(coordinates: track.map({$0.position}),
                    contourStyle: .straight)
        .stroke(.black.opacity(0.6),
                style: .init(lineWidth: 2,
                             lineCap: .round,
                             lineJoin: .round,
                            dash: [1, 5]))
    }
}

#Preview {
    Map() {
        MapContents.fantomTrack(.filledTrack)
    }
}
