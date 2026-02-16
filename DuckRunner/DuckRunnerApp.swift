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
    let trackService: any TrackServiceProtocol = TrackService()
    let locationService: any LocationServiceProtocol = LocationService()
    let storageService: any TrackStorageProtocol = TrackRepository()

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Map", systemImage: "map") {
                    BaseMapView(trackService: trackService,
                                locationService: locationService,
                                storageService: storageService)
                }
                Tab("History", systemImage: "book.pages") {
                    TrackHistoryView(vm: TrackHistoryViewModel(storage: storageService))
                }
            }
        }
    }
}
