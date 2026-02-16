//
//  TrackServiceSerivce.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Combine
import Foundation

@MainActor
final class TrackService: TrackServiceProtocol {
    let currentTrack: CurrentValueSubject<Track?, Never> = .init(nil)
    
    private var _currentTrack: Track? = nil {
        didSet {
            self.currentTrack.send(_currentTrack)
        }
    }
    
    func appendTrackPosition(_ point: TrackPoint) throws(TrackServiceError) {
        guard _currentTrack != nil else {
            throw.noCurrentTrack
        }
        guard _currentTrack?.stopDate == nil else {
            throw .currentTrackIsFinished
        }
        
        self._currentTrack?.points.append(point)
    }
    
    func startTrack(at date: Date) {
        self._currentTrack = .init(points: [], startDate: date)
    }
    
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
