//
//  TrackServiceSerivce.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Combine
import Foundation

/// Service that manages the in-memory state and mutation of a live track during a session.
/// Provides methods for starting, stopping, and updating a track as the user moves.
@MainActor
final class LiveTrackService: LiveTrackServiceProtocol {
    /// Publishes the current active track or nil if there is no ongoing session.
    let currentTrack: CurrentValueSubject<Track?, Never> = .init(nil)
    
    /// Internal storage for the current track being recorded.
    private var _currentTrack: Track? = nil {
        didSet {
            self.currentTrack.send(_currentTrack)
        }
    }
    
    /// Appends a new point to the current track if recording is active.
    func appendTrackPosition(_ point: TrackPoint) throws(TrackServiceError) {
        guard _currentTrack != nil else {
            throw.noCurrentTrack
        }
        guard _currentTrack?.stopDate == nil else {
            throw .currentTrackIsFinished
        }
        
        self._currentTrack?.points.append(point)
    }
    
    /// Begins a new track recording session at the specified date.
    func startTrack(at date: Date) {
        self._currentTrack = .init(points: [], startDate: date)
    }
    
    /// Stops the current track session at the specified date and marks it as finished.
    @discardableResult
    func stopTrack(at date: Date) throws(TrackServiceError) -> Track {
        guard var currentTrack = _currentTrack else {
            throw .noCurrentTrack
        }
        currentTrack.stopDate = date
        self._currentTrack = currentTrack
        return currentTrack
    }
    
    
}
