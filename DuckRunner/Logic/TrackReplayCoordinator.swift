//
//  TrackReplayCoordinator.swift
//  DuckRunner
//
//  Created by vladukha on 20.02.2026.
//

import Foundation
import Combine

enum TrackReplayAction {
    case select(Track)
    case deselect
}

protocol TrackReplayCoordinatorProtocol: Actor {
    nonisolated
    var selectedTrackPublisher: PassthroughSubject<TrackReplayAction, Never> { get }
    func selectTrackToReplay(_ track: Track)
    func deselectReplay()
}

nonisolated
final actor TrackReplayCoordinator: TrackReplayCoordinatorProtocol {
    nonisolated
    let selectedTrackPublisher: PassthroughSubject<TrackReplayAction, Never> = .init()
    
    func selectTrackToReplay(_ track: Track) {
        selectedTrackPublisher.send(.select(track))
    }
    
    func deselectReplay() {
        selectedTrackPublisher.send(.deselect)
    }
}
