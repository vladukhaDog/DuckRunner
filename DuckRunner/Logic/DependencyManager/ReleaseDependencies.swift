//
//  ReleaseDependencies.swift
//  DuckRunner
//
//  Created by vladukha on 22.02.2026.
//

import Foundation

extension DependencyManager {
    static public let production: DependencyManager = {
        let trackService = LiveTrackService()
        let locationService = LocationService()
        let storageService = TrackRepository()
        let mapSnapshotGenerator = MapSnapshotGenerator()
        let cacheFileManager = CacheFileManager()
        let mapSnippetCache = TrackMapSnippetCache(fileManager: cacheFileManager)
        let trackReplayCoordinator = TrackReplayCoordinator()
        let tabRouter = TabRouter()
            
        
        return .init(trackService: trackService,
                     locationService: locationService,
                     storageService: storageService,
                     mapSnapshotGenerator: mapSnapshotGenerator,
                     mapSnippetCache: mapSnippetCache,
                     trackReplayCoordinator:trackReplayCoordinator,
                     tabRouter: tabRouter,
                     cacheFileManager: cacheFileManager)
    }()
}
