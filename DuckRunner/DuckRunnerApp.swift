//
//  DuckRunnerApp.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//

import SwiftUI
import SwiftData

@main
struct DuckRunnerApp: App {
    let trackService: any LiveTrackServiceProtocol = LiveTrackService()
    let locationService: any LocationServiceProtocol = LocationService()
    let storageService: any TrackStorageProtocol = TrackRepository()
    let mapSnapshotGenerator: any MapSnapshotGeneratorProtocol = MapSnapshotGenerator()
    let mapSnippetCache: any TrackMapSnippetCacheProtocol = TrackMapSnippetCache(fileManager: CacheFileManager())
    let trackReplayCoordinator: any TrackReplayCoordinatorProtocol = TrackReplayCoordinator()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Map", systemImage: "map") {
                    BaseMapView(trackService: trackService,
                                locationService: locationService,
                                storageService: storageService,
                                trackReplayCoordinator: trackReplayCoordinator)
                }
                Tab("History", systemImage: "book.pages") {
                    TrackHistoryView(storage: storageService,
                                     mapSnapshotGenerator: mapSnapshotGenerator,
                                     mapSnippetCache: mapSnippetCache,
                                     trackReplayCoordinator: trackReplayCoordinator)
                }
            }
            
        }
    }
}
