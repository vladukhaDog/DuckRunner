//
//  SettingsService.swift
//  DuckRunner
//
//  Created by vladukha on 21.02.2026.
//

import Foundation
import CoreLocation

nonisolated
final class SettingsService {
    static let shared = SettingsService()
    
    public var replayCompletionThreshold: Double = 0.7
    
    public var speedToAutoStartReplay: CLLocationSpeed = 15
    
    public var checkpointDistanceActivateThreshold: CLLocationDistance = 50
    
    public var checkpointDistanceInterval: CLLocationDistance = 300
    
}
