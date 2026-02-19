//
//  TrackServiceProtocol.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//


import Combine
import Foundation

protocol LiveTrackServiceProtocol: ObservableObject {
    var currentTrack: CurrentValueSubject<Track?, Never> { get }
    func appendTrackPosition(_ point: TrackPoint) throws(TrackServiceError)
    func startTrack(at date: Date)
    @discardableResult
    func stopTrack(at date: Date) throws(TrackServiceError) -> Track
}
