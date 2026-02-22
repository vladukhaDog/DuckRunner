//
//  StopPointAnnotation 2.swift
//  DuckRunner
//
//  Created by vladukha on 21.02.2026.
//

import SwiftUI
import MapKit

final class CheckpointAnnotation: NSObject, FlagAnnotation {
    
    var outlineWidth: CGFloat = 3
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let id: String = UUID().uuidString
    
    let annotationPointSize: CGFloat = 15
    
    var image: AnnotationImage
    
    
    init(coordinate: CLLocationCoordinate2D, passed: Bool) {
        self.coordinate = coordinate
        self.image = .init(image: "flag",
                           fillColor: passed ? .green : .gray,
                           strokeColor: .black)
        self.title = passed ? "." : "^"
    }
    
}


#Preview {
    TrackingMapView(overlays: [ReplayTrackOverlay(track: .roadInSPB)],
                    markers: [CheckpointAnnotation(coordinate: Track.filledTrack
                        .points.first!
                        .position,
                                                   passed: true),
                              CheckpointAnnotation(coordinate: Track.filledTrack
                                  .points.last!
                                  .position,
                                                             passed: false)],
                    mapMode: .bounds(.filledTrack))
    .ignoresSafeArea()
}

