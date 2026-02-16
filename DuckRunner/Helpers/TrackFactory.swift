//
//  TrackFactory.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import Foundation

extension Track {
    static let emptyTrack = Track(startDate: .now)
    static let filledTrack = Track(points: .roadInSPB, startDate: "16.02.2026 16:00:00".toDate(format: "dd.MM.yyyy H:mm:ss"),
                                   stopDate: "16.02.2026 16:04:02".toDate(format: "dd.MM.yyyy H:mm:ss"))
}
