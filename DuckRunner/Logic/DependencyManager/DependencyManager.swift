//
//  DependencyManager.swift
//  DuckRunner
//
//  Created by vladukha on 22.02.2026.
//

import Foundation

final class DependencyManager {
    let trackService: any LiveTrackServiceProtocol
    let locationService: any LocationServiceProtocol
    let storageService: any TrackStorageProtocol
    let mapSnapshotGenerator: any MapSnapshotGeneratorProtocol
    let mapSnippetCache: any TrackMapSnippetCacheProtocol
    let trackReplayCoordinator: any TrackReplayCoordinatorProtocol
    let tabRouter: any TabRouterProtocol
    let cacheFileManager: any CacheFileManagerProtocol
    
    init(
        trackService: any LiveTrackServiceProtocol,
        locationService: any LocationServiceProtocol,
        storageService: any TrackStorageProtocol,
        mapSnapshotGenerator: any MapSnapshotGeneratorProtocol,
        mapSnippetCache: any TrackMapSnippetCacheProtocol,
        trackReplayCoordinator: any TrackReplayCoordinatorProtocol,
        tabRouter: any TabRouterProtocol,
        cacheFileManager: any CacheFileManagerProtocol
    ) {
            self.trackService = trackService
            self.locationService = locationService
            self.storageService = storageService
            self.mapSnapshotGenerator = mapSnapshotGenerator
            self.mapSnippetCache = mapSnippetCache
            self.trackReplayCoordinator = trackReplayCoordinator
            self.tabRouter = tabRouter
            self.cacheFileManager = cacheFileManager
    }
}
