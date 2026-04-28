//
//  AppComponent.swift
//  Routka
//
//  Created by vladukha on 23.04.2026.
//
import NeedleFoundation

nonisolated
class AppComponent: BootstrapComponent {
    @MainActor
    public var routers: [String: Router] {
        shared { ["Tracks": Router()] }
    }
    
    @MainActor
    public var storageService: any TrackStorageProtocol {
        shared { TrackRepository() }
    }
    
    @MainActor
    public var mapSnippetCache: any TrackMapSnippetCacheProtocol {
        shared { TrackMapSnippetCache(fileManager: self.cacheFileManager) }
    }
    
    @MainActor
    public var trackFileService: any TrackFileServiceProtocol {
        shared { TrackFileService(trackStorage: self.storageService) }
    }
    @MainActor
    public var trackReplayCoordinator: any TrackReplayCoordinatorProtocol {
        shared { TrackReplayCoordinator() }
    }
    
    @MainActor
    public var cacheFileManager: any CacheFileManagerProtocol {
        shared { CacheFileManager() }
    }
    
    @MainActor
    public var tabRouter: any TabRouterProtocol {
        shared { TabRouter() }
    }
    
    @MainActor
    public var locationService: any LocationServiceProtocol {
        shared { LocationService() }
    }
    
    @MainActor
    public var measuredTrackStorageService: any MeasuredTrackStorageProtocol {
        shared { MeasuredTrackRepository() }
    }
    
    @MainActor
    public var mapSnapshotGenerator: any MapSnapshotGeneratorProtocol {
        shared { MapSnapshotGenerator() }
    }
    
    @MainActor
    var root: RootComponent {
        RootComponent(parent: self)
    }

}
