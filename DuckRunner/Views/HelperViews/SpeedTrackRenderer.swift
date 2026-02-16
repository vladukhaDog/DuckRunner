//
//  SpeedTrackRenderer.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import MapKit
/*
0-30 km/h - 0-8.333 m/s - синий какой нить максимально neutral apple
30-60km/h - 8.333-16.666 m/s - green
60-80 km/h - 16.666 - 22.222 m/s - yellow
80-110 km/h - 22.222 - 30.555 m/s - lava orange
110+ km/h - 30.555+m/s - red
*/


/// Overlay which controls how to draw a line of a Track
final class SpeedTrackRenderer: MKOverlayRenderer {
    enum SpeedBucket {
        case slow, regular, speedy, dangerous, extreme
    }
    
    func bucket(for speed: CLLocationSpeed) -> SpeedBucket {
        switch speed {
        case ..<9:
            return .slow
        case ..<17:
            return .regular
        case ..<23:
            return .speedy
            case ..<31:
            return .dangerous
        default:
            return .extreme
        }
    }

    func color(for bucket: SpeedBucket) -> UIColor {
        switch bucket {
        case .slow:
            return .cyan
        case .regular:
            return .systemGreen
        case .speedy:
            return .yellow
        case .dangerous:
            return .orange
        case .extreme:
            return .red
        }
    }

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

            let bucket = bucket(for: overlay.speeds[i])
            context.setStrokeColor(color(for: bucket).cgColor)

            context.beginPath()
            context.move(to: p1)
            context.addLine(to: p2)
            context.strokePath()
        }
    }
}
