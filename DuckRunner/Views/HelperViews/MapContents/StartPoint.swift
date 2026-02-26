//
//  StartPoint.swift
//  DuckRunner
//
//  Created by vladukha on 26.02.2026.
//
import SwiftUI
import MapKit

extension MapContents {
    /// Start checkpoint
    @MapContentBuilder
    static public func startPoint(_ trackPoint: TrackPoint) -> some MapContent {
        
        Annotation(coordinate: trackPoint.position,
                   anchor: .bottom) {
            VStack(spacing: 5) {
                HStack(spacing: 2) {
                    Image(systemName: "flag")
                        .foregroundStyle(Color.green)
                        .stroke(color: .black, width: 0.2)
                    Text("START")
                        .stroke(color: .black, width: 1)
                }
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
            MapContents.startPoint(Track.filledTrack.points.first!)
        }
    }
}
