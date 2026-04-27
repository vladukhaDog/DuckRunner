//
//  RootDependency.swift
//  Routka
//
//  Created by vladukha on 23.04.2026.
//
import NeedleFoundation
import Foundation

protocol RootDependency: Dependency {
    var tabRouter: any TabRouterProtocol { get }
    var routers: [String: Router] { get }
    var trackFileService: any TrackFileServiceProtocol { get }
}


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
