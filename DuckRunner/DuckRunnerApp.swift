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
    @State var tabRouter: TabRouter = TabRouter()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabRouter.selectedTab) {
                
                BaseMapView(trackService: trackService,
                            locationService: locationService,
                            storageService: storageService,
                            trackReplayCoordinator: trackReplayCoordinator)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag("Map")
                TrackHistoryView(storage: storageService,
                                 mapSnapshotGenerator: mapSnapshotGenerator,
                                 mapSnippetCache: mapSnippetCache,
                                 trackReplayCoordinator: trackReplayCoordinator,
                                 tabRouter: tabRouter)
                .tabItem {
                    Label("History", systemImage: "book.pages")
                }
                .tag("History")
            }
            
        }
    }
}
