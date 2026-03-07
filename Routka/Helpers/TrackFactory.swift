//
//  TrackFactory.swift
//  Routka
//
//  Created by vladukha on 16.02.2026.
//

import Foundation

extension Track {
    static let emptyTrack = Track()
    static let filledTrack = Track(points: .roadInSPB)
    static func newFilledTrack() -> Track {
        return Track(points: .roadInSPB)
    }
}
