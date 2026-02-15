//
//  TrackServiceError.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//


enum TrackServiceError: Error {
    case noCurrentTrack
    case currentTrackIsFinished
}