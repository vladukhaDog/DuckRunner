//
//  TracksTabViewModelProtocol.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//
import Foundation

protocol TracksTabViewModelProtocol: Observable {
    var showLimit: Int { get }
    var historyTracks: [Track] { get }
    var measuredTracks: [MeasuredTrack] { get }
    var importedTracks: [Track] { get }
    
    func trackHistoryCellComponent(track: Track,
                                   unitSpeed: UnitSpeed) -> TrackHistoryCellComponent
    func openTrack(_ track: Track)
    func showImporter()
    func openMap()
    func openMeasuredTrack(_ measure: MeasuredTrack)
    func openTrackHistory()
    func openMeasuredTracks()
    func openImportedTracks()
}
