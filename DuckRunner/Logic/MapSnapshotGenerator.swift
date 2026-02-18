//
//  MapSnapshotGenerator.swift
//  DuckRunner
//
//  Created by vladukha on 18.02.2026.
//


import MapKit

protocol MapSnapshotGeneratorProtocol {
    func generateSnapshot(track: Track,
                          size: CGSize
    ) async throws -> UIImage? 
}

/// Generates a snapshot image for a given map‑rect and draws the supplied overlay
/// using its renderer.
final class MapSnapshotGenerator: MapSnapshotGeneratorProtocol {
    init() {
    }
    // Source - https://stackoverflow.com/a/35321619
    // Retrieved 2026-02-18, License - CC BY-SA 4.0

    func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))

        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
    struct NormalizedTrackPoint {
        /// The geographic coordinate for this track point.
        let position: CGPoint
        /// The speed measured at this point.
        let speed: CLLocationSpeed
        /// The date and time this point was recorded.
        let date: Date
        /// Initializes a new TrackPoint with the given location, speed, and timestamp.
        init(position: CGPoint, speed: CLLocationSpeed, date: Date) {
            self.position = position
            self.speed = speed
            self.date = date
        }
    }

    /// Creates a snapshot for `mapRect` and draws the overlay with its renderer.
    /// - Parameters:
    ///   * mapRect: The area to snapshot (in MKMapRect coordinates).
    ///   * overlay: The overlay that will be rendered on the snapshot.
    ///   * completion: Called with the resulting UIImage or an error.
    func generateSnapshot(track: Track,
                          size: CGSize
    ) async throws -> UIImage? {
//        if let cachedImage = await cache?.getSnippet(for: track, size: size) {
//            return cachedImage
//        }
        //  Configure snapshot options
        let options = MKMapSnapshotter.Options()
        let region = track.points.regionOfATrack()
        options.region = region
        options.size = size
        options.mapType = .standard
        options.traitCollection = .init(userInterfaceStyle: .dark)
        //  Create snapshotter
        let snapshotter = MKMapSnapshotter(options: options)
        let snapshot = try await snapshotter.start()
        
        let normalizedPoints = track.points.map { point in
            NormalizedTrackPoint(position: snapshot.point(for: point.position),
                                 speed: point.speed,
                                 date: point.date)
        }
        let paths = makeColoredPaths(from: normalizedPoints)
        
        let finalImage = drawColoredPaths(on: snapshot.image,
                                segments: paths,
                                lineWidth: 3,
                                startPoint: normalizedPoints.first?.position,
                                stopPoint: normalizedPoints.last?.position)
//        await cache?.cacheSnippet(finalImage, for: track, size: size)
        return finalImage
    }

    // MARK: - Helpers
    
    struct ColoredPathSegment {
        let path: UIBezierPath
        let color: UIColor
    }
    
    func drawColoredPaths(
        on baseImage: UIImage,
        segments: [ColoredPathSegment],
        lineWidth: CGFloat,
        startPoint: CGPoint?,
        stopPoint: CGPoint?
    ) -> UIImage {

        let format = UIGraphicsImageRendererFormat()
        format.scale = baseImage.scale
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(
            size: baseImage.size,
            format: format
        )

        return renderer.image { context in
            let cg = context.cgContext

            // Draw base image
            baseImage.draw(
                in: CGRect(origin: .zero, size: baseImage.size)
            )

            // ---- Draw path segments ----
            cg.setLineWidth(lineWidth)
            cg.setLineCap(.round)
            cg.setLineJoin(.round)
            cg.setBlendMode(.normal)

            for segment in segments {
                cg.addPath(segment.path.cgPath)
                cg.setStrokeColor(segment.color.cgColor)
                cg.strokePath()
            }

            // ---- Draw markers ----
            if let startPoint {
                drawMarker(
                    at: startPoint,
                    title: "Start",
                    in: context
                )
            }

            if let stopPoint {
                drawMarker(
                    at: stopPoint,
                    title: "Stop",
                    in: context
                )
            }
        }
    }
    private func drawMarker(
        at point: CGPoint,
        title: String,
        in context: UIGraphicsImageRendererContext
    ) {

        let pinSize: CGFloat = 22
        let textOffset: CGFloat = 4
        let strokeWidth: CGFloat = 8

        let fillColor = UIColor.white
        let strokeColor = UIColor.black

        // ---- Draw SF Symbol pin ----
        let config = UIImage.SymbolConfiguration(paletteColors: [UIColor.black, UIColor.systemMint])
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: pinSize, weight: .bold)
        config.applying(sizeConfig)
        if let pinImage = UIImage( systemName: "mappin.circle.fill",
                                   withConfiguration: config ){
            let pinOrigin = CGPoint( x: point.x - pinSize / 2, y: point.y - pinSize )
            pinImage.draw(in: CGRect(origin: pinOrigin, size: CGSize(width: pinSize, height: pinSize)) )
        }

        let font = UIFont.systemFont(ofSize: 15, weight: .bold)

        // ---- Stroke pass ----
        let strokeAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.clear,
            .strokeColor: strokeColor,
            .strokeWidth: strokeWidth   // POSITIVE = stroke only
        ]

        // ---- Fill pass ----
        let fillAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: fillColor
        ]

        let textSize = title.size(withAttributes: fillAttributes)

        let textPoint = CGPoint(
            x: point.x - textSize.width / 2,
            y: point.y + textOffset
        )

        // Draw stroke first
        title.draw(at: textPoint, withAttributes: strokeAttributes)

        // Draw fill on top
        title.draw(at: textPoint, withAttributes: fillAttributes)
    }


    func makeColoredPaths(from points: [NormalizedTrackPoint]) -> [ColoredPathSegment] {
        guard points.count >= 2 else { return [] }

        var result: [ColoredPathSegment] = []

        for i in 0..<(points.count - 1) {
            let start = points[i]
            let end = points[i + 1]

            let bucket = SpeedBucket(for: start.speed)

            let path = UIBezierPath()
            path.move(to: start.position)
            path.addLine(to: end.position)

            result.append(
                ColoredPathSegment(
                    path: path,
                    color: bucket.color()
                )
            )
        }

        return result
    }

}
