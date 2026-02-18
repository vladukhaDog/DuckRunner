//
//  SpeedTrackRenderer.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import MapKit

/// Overlay which controls how to draw a line of a Track
final class SpeedTrackRenderer: MKOverlayRenderer {
    override func draw(
        _ mapRect: MKMapRect,
        zoomScale: MKZoomScale,
        in context: CGContext
    ) {
        guard let overlay = overlay as? SpeedTrackOverlay,
              overlay.points.count > 1 else { return }

        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(10 / zoomScale)

        for i in 0..<(overlay.points.count - 1) {
            let p1 = point(for: overlay.points[i])
            let p2 = point(for: overlay.points[i + 1])

            let bucket = SpeedBucket(for: overlay.speeds[i])
            context.setStrokeColor(bucket.color().cgColor)

            context.beginPath()
            context.move(to: p1)
            context.addLine(to: p2)
            context.strokePath()
        }
    }
}
