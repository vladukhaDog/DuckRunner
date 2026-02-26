//
//  SpeedTrack.swift
//  DuckRunner
//
//  Created by vladukha on 26.02.2026.
//
import SwiftUI
import MapKit

extension MapContents {
    /// Track polyline that colors the track by speed points
    @MapContentBuilder
    static public func speedTrack(_ track: Track) -> some MapContent {
        Self.speedTrack(track.points)
    }
    
    /// Track polyline that colors the track by speed points
    @MapContentBuilder
    static public func speedTrack(_ trackPoints: [TrackPoint] ) -> some MapContent {
        if trackPoints.count > 1 {
            ForEach(0..<(trackPoints.count - 1), id: \.self) { index in
                
                let p1 = trackPoints[index]
                let p2 = trackPoints[index + 1]
                
                let bucket = SpeedBucket(for: p2.speed)
                MapPolyline(coordinates: [p1.position, p2.position],
                            contourStyle: .straight)
                .stroke(Color.init(uiColor: bucket.color()),
                        style: .init(lineWidth: 6,
                                     lineCap: .round,
                                     lineJoin: .round))
                
            }
        }
    }
}

#Preview {
    Map() {
        MapContents.speedTrack(.filledTrack)
    }
}
