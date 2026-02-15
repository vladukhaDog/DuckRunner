//
//  BaseMapViewModelProtocol.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//
import Foundation
import SwiftUI
import MapKit

protocol BaseMapViewModelProtocol: ObservableObject, TrackControllerProtocol {
    var currentTrack: Track? { get }
    var currentPosition: MapCameraPosition { get set }
    var currentSpeed: CLLocationSpeed? { get set }
    func startTrack()
    func stopTrack() throws
}

