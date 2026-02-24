//
//  SpeedTrackRenderer 2.swift
//  DuckRunner
//
//  Created by vladukha on 20.02.2026.
//
import MapKit

/// Overlay which controls how to draw a line of a Track
final class ReplayTrackRenderer: MKOverlayRenderer {
    override func draw(
        _ mapRect: MKMapRect,
        zoomScale: MKZoomScale,
        in context: CGContext
    ) {
        guard let overlay = overlay as? ReplayTrackOverlay,
              overlay.points.count > 1 else { return }

        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(5 / zoomScale)
        context.setStrokeColor(UIColor.cyan.cgColor)
        let points = overlay.points
        
        // Build and stroke a path through all overlay points
        guard let first = points.first else { return }
        let path = CGMutablePath()
        let firstCGPoint = point(for: first)
        path.move(to: firstCGPoint)
        if points.count > 1 {
            for i in 1..<points.count {
                let cgPoint = point(for: points[i])
                path.addLine(to: cgPoint)
            }
        }
        context.addPath(path)
        context.strokePath()
    }
}
