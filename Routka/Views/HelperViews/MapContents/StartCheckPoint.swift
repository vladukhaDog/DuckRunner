//
//  StartPoint.swift
//  Routka
//
//  Created by vladukha on 26.02.2026.
//
import SwiftUI
import MapKit

extension MapContents {
    /// Start checkpoint
    @MapContentBuilder
    static public func startCheckPoint(_ trackPoint: TrackPoint) -> some MapContent {
        
        Annotation(coordinate: trackPoint.position,
                   anchor: .bottom) {
            StartCheckPointView(startPoint: trackPoint)
        } label: {
        }

    }
}

private struct StartCheckPointView: View {
    let startPoint: TrackPoint

    
    var body: some View {
        VStack(spacing: 4) {
            Text("START")
                .font(.caption)
                .foregroundStyle(Color.white)
                .stroke(color: .black, width: 0.5)
            .bold()
            let unFilledAmount = 0.75
            let degree = (180 - (360 - (360 * (unFilledAmount)))) / 2
            ZStack {
                Circle()
                   .trim(from: 0.0,
                         to: unFilledAmount)
                   .stroke(Color.green.gradient.opacity(0.8),
                           style: .init(lineWidth: 4,
                                        lineCap: .round))
                   .rotationEffect(.degrees(180))
                   .rotationEffect(.degrees((-degree)))
            }
               .frame(width: 20)
        }
    }
}

#Preview {
    VStack {
        Map() {
            MapContents.speedTrack(.filledTrack)
            MapContents.startCheckPoint(Track.filledTrack.points.first!)
        }
    }
}
#Preview("Inside View") {
    StartCheckPointView(startPoint: Track.filledTrack.points.first!)
}


