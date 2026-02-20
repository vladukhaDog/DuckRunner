//
//  FlagAnnotation.swift
//  DuckRunner
//
//  Created by vladukha on 20.02.2026.
//
import MapKit

struct AnnotationImage {
    let image: String
    let fillColor: UIColor
    let strokeColor: UIColor
}

/// Annotation to draw image of a start or stop, for example
protocol FlagAnnotation: NSObject, MKAnnotation {
    var image: AnnotationImage { get }
    var annotationPointSize: CGFloat { get }
    var coordinate: CLLocationCoordinate2D { get }
    var outlineWidth: CGFloat { get }
    func makeImage() -> UIImage
}

extension FlagAnnotation {
    func makeImage() -> UIImage {

        // Layout constants
        let symbolPointSize: CGFloat = annotationPointSize
        // Brain rot optional String? from objc MKAnnotation
        let text: String = (self.title ?? "") ?? ""
        let font = UIFont.systemFont(ofSize: annotationPointSize, weight: .semibold)
        
        let outlineWidth: CGFloat = self.outlineWidth
        let padding: CGFloat = outlineWidth

        // Text size
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        let textSize = (text as NSString).size(withAttributes: textAttributes)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: symbolPointSize, weight: .bold)
        
        let symbolImage = UIImage(systemName: self.image.image, withConfiguration: symbolConfig)!
            .withRenderingMode(.alwaysTemplate)

        let imageSize = CGSize(
            width: max(symbolImage.size.width, textSize.width) + padding * 2,
            height: symbolImage.size.height + padding + textSize.height + padding
        )
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: UIGraphicsImageRendererFormat.default())

        return renderer.image { context in
            let ctx = context.cgContext
            ctx.setAllowsAntialiasing(true)
            ctx.setShouldAntialias(true)
            ctx.interpolationQuality = .high

            let centerX = imageSize.width / 2

            // MARK: - Draw Symbol (Outlined)

            
            let symbolRect = CGRect(
                x: centerX - symbolImage.size.width / 2,
                y: padding,
                width: symbolImage.size.width,
                height: symbolImage.size.height
            )

            ctx.saveGState()
            // Outline
            for dx in [-1, 0, 1] {
                for dy in [-1, 0, 1] where dx != 0 || dy != 0 {
                    let offsetRect = symbolRect.offsetBy(dx: CGFloat(dx), dy: CGFloat(dy))
                    symbolImage
                        .withTintColor(image.strokeColor)
                        .draw(in: offsetRect)
                }
            }

            // Fill
            symbolImage
                .withTintColor(image.fillColor)
                .draw(in: symbolRect)

            ctx.restoreGState()
            
            // MARK: - Draw text (outside-only outline)

            let attributed = NSAttributedString(string: text, attributes: [
                .font: font
            ])

            let line = CTLineCreateWithAttributedString(attributed)
            let runs = CTLineGetGlyphRuns(line) as! [CTRun]

            let textPath = CGMutablePath()

            for run in runs {
                let attributes = CTRunGetAttributes(run) as NSDictionary
                let ctFont = attributes[kCTFontAttributeName as NSAttributedString.Key] as! CTFont

                for i in 0..<CTRunGetGlyphCount(run) {
                    var glyph = CGGlyph()
                    var position = CGPoint.zero

                    CTRunGetGlyphs(run, CFRangeMake(i, 1), &glyph)
                    CTRunGetPositions(run, CFRangeMake(i, 1), &position)

                    if let glyphPath = CTFontCreatePathForGlyph(ctFont, glyph, nil) {
                        let transform = CGAffineTransform(translationX: position.x, y: position.y)
                        textPath.addPath(glyphPath, transform: transform)
                    }
                }
            }

            // Position text path (UIKit → Core Graphics flip)
            ctx.saveGState()
            ctx.translateBy(x: (imageSize.width / 2) - (textSize.width / 2),
                            y: imageSize.height / 2 + textSize.height / 2 + padding)
            ctx.scaleBy(x: 1, y: -1)
            
            // Outside-only outline
            let outlinePath = textPath.copy(
                strokingWithWidth: outlineWidth,
                lineCap: .round,
                lineJoin: .round,
                miterLimit: 0
            )

            ctx.addPath(outlinePath)
            ctx.setFillColor(UIColor.black.cgColor)
            ctx.fillPath()

            // Fill text on top
            ctx.addPath(textPath)
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fillPath()

            ctx.restoreGState()

        }
    }
}
