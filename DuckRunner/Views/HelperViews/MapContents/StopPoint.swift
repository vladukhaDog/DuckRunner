//
//  StopPoint.swift
//  DuckRunner
//
//  Created by vladukha on 26.02.2026.
//
import MapKit
import SwiftUI

extension MapContents {
    /// Stop checkpoint
    @MapContentBuilder
    static public func stopPoint(_ trackPoint: TrackPoint) -> some MapContent {
        
        Annotation(coordinate: trackPoint.position,
                   anchor: .bottom) {
            VStack(spacing: 1) {
                Image(systemName: "flag.pattern.checkered.2.crossed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(Color.green)
                    .stroke(color: .black, width: 0.2)
                .bold()
                Circle()
                    .fill(Color.cyan)
                    .stroke(.red, lineWidth: 2, antialiased: true)
                    .frame(width: 5, height: 5)
                    .offset(y: 2.5)
            }
        } label: {
        }

    }
}

#Preview {
    VStack {
        Map() {
            MapContents.speedTrack(.filledTrack)
            MapContents.stopPoint(Track.filledTrack.points.first!)
        }
    }
}
