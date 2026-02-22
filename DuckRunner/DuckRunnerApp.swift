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
    @State var tabRouter: any TabRouterProtocol
    private let dependencies: DependencyManager
    init() {
        self.dependencies = .production
        self.tabRouter = dependencies.tabRouter
    }
    
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabRouter.selectedTab) {
                
                BaseMapView(dependencies: .production)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag("Map")
                TrackHistoryView(dependencies: .production)
                .tabItem {
                    Label("History", systemImage: "book.pages")
                }
                .tag("History")
                SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag("Settings")
            }
            
        }
    }
}
