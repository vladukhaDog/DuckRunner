//
//  RootDependency.swift
//  Routka
//
//  Created by vladukha on 23.04.2026.
//
import NeedleFoundation
import Foundation

// MARK: - List of dependencies
protocol RootDependency: Dependency {
    var tabRouter: any TabRouterProtocol { get }
    var routers: [String: Router] { get }
    var trackFileService: any TrackFileServiceProtocol { get }
}

// MARK: - Main Component creation
nonisolated
final class RootComponent: Component<RootDependency> {
    
    @MainActor
    public var trackDetailBuilder: any TrackDetailBuilder {
        shared { TrackDetailBuilderImpl(component: self) }
    }
    
    @MainActor
    var viewModel: RootViewModel {
        RootViewModel(tabRouter: dependency.tabRouter,
                      routers: dependency.routers,
                      component: self,
                      fileServiceWrapperNavigator: fileServiceWrapperNavigator,
                      fileService: dependency.trackFileService)
    }
    
    @MainActor
    var view: RootView {
        RootView(vm: viewModel)
    }
    
    @MainActor
    var tracksTab: TracksTabComponent {
        TracksTabComponent(parent: self)
    }
    
    @MainActor
    var map: BaseMapComponent {
        BaseMapComponent(parent: self)
    }
    
    @MainActor
    var settings: SettingsComponent {
        SettingsComponent(parent: self)
    }
    
    @MainActor
    func trackDetail(_ track: Track) -> TrackDetailComponent {
        TrackDetailComponent(parent: self, track: track)
    }
    
    @MainActor
    var fileServiceWrapperNavigator: any FileServiceWrapperRouting {
        FileServiceWrapperNavigator(component: self,
                                    tabRouter: dependency.tabRouter,
                                    routers: dependency.routers)
    }
}


// MARK: - FileService Navigator
final class FileServiceWrapperNavigator: FileServiceWrapperRouting {
    
    private let component: RootComponent
    private let tabRouter: any TabRouterProtocol
    private let routers: [String: Router]

    init(component: RootComponent,
         tabRouter: any TabRouterProtocol,
         routers: [String: Router]) {
        self.component = component
        self.tabRouter = tabRouter
        self.routers = routers
    }
    
    func openTrack(_ track: Track) {
        tabRouter.selectedTab = "Tracks"
        routers[tabRouter.selectedTab]?.popToRoot()
        let trackRoute = component.trackDetail(track).route
        routers[tabRouter.selectedTab]?.push(trackRoute)
    }
}
