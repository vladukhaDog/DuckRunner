//
//  TrackStorage.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import Foundation
import Combine
/// Action that was made on respected object with said object
enum StorageAction {
    case created(Track)
    case deleted(Track)
    case updated(Track)
}

protocol TrackStorageProtocol {
    func getTracks(for date: Date) async -> [Track]
    func getAllTracks() async -> [Track]
    func addTrack(_ track: Track) async throws
    func deleteTrack(_ track: Track) async
    func updateTrack(_ track: Track) async throws
    /// Ge a combine publisher that notifies us that something happened with an object related to this class
    var actionPublisher: PassthroughSubject<StorageAction, Never> { get }
}
