//
//  TrackControllerProtocol.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Foundation

protocol TrackControllerProtocol: ObservableObject {
    var currentTrack: Track? { get }
    func startTrack()
    func stopTrack() throws
}
