//
//  TrackType.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//

import Foundation

/// Type of a track explaining where it came from or where it belongs
enum TrackType: String, Codable, Hashable {
    /// Track was recorded by us and belongs in regular history
    case record
    /// Track was imported from outside world
    case `import`
    /// Track was recorded as a measurement for something
    case measurement
}
