//
//  RoutkaApp.swift
//  Routka
//
//  Created by vladukha on 15.02.2026.
//

import SwiftUI

public let mainLogger: MainLogger = .init("RoutkaCategory")
private let appComponent = AppComponent()
/// The main app entry point for the Routka application.
@main
struct RoutkaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            appComponent.root.view
        }
    }
    
}
//    @State var tabRouter: any TabRouterProtocol
//    private let alertController: AlertController = .shared
//    private let dependencies: DependencyManager
//    private let baseMapViewModel: BaseMapViewModel
//    private let tracksTabViewModel: TracksTabViewModel
//    private let preferredColorScheme: ColorScheme?
//
//    init() {
//        self.dependencies = .production(tabs: [
//            "Tracks"
//                                              ])
//        self.tabRouter = dependencies.tabRouter
//        self.baseMapViewModel = BaseMapViewModel(dependencies: dependencies)
//        self.tracksTabViewModel = .init(dependencies: dependencies)
//        self.preferredColorScheme = ProcessInfo.processInfo.arguments.contains("UITestingDarkModeEnabled") ? .dark : nil
//    }
//    
//    /// The main scene of the application providing the app's user interface structure.
//    var body: some Scene {
//        WindowGroup {
//            TabView(selection: $tabRouter.selectedTab) {
//                Tab("Map", systemImage: "map", value: "map") {
//                    BaseMapView(vm: baseMapViewModel,
//                                dependencies: dependencies)
//                }
//                if let router = dependencies.routers["Tracks"] {
//                    Tab("Tracks", systemImage: "book.pages", value: "Tracks") {
//                        NavigatableView(router) {
//                            TracksTabView(vm: tracksTabViewModel, dependencies: dependencies)
//                        }
//                    }
//                    .accessibilityIdentifier("tracksTab")
//                }
//            }
//            .disclaimerOnce()
//            .fileManager(managedBy: dependencies)
//            .alertable(alertController,
//                       alignment: .top)
//            .preferredColorScheme(preferredColorScheme)
//        }
//    }
//}
