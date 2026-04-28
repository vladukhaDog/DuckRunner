//
//  RootViewModel.swift
//  Routka
//
//  Created by vladukha on 23.04.2026.
//
import SwiftUI
import vladukhaAlerts

@Observable
final class RootViewModel {
    var tabRouter: any TabRouterProtocol
    let routers: [String: Router]
    let alertController: AlertController = .shared
    let component: RootComponent
    let fileServiceWrapperNavigator: any FileServiceWrapperRouting
    let fileService: any TrackFileServiceProtocol
    let preferredColorScheme: ColorScheme?
    
    
    init(tabRouter: any TabRouterProtocol,
         routers: [String: Router],
         component: RootComponent,
         fileServiceWrapperNavigator: any FileServiceWrapperRouting,
         fileService: any TrackFileServiceProtocol) {
        self.tabRouter = tabRouter
        self.routers = routers
        self.component = component
        self.fileServiceWrapperNavigator = fileServiceWrapperNavigator
        self.fileService = fileService
        self.preferredColorScheme = ProcessInfo.processInfo.arguments.contains("UITestingDarkModeEnabled") ? .dark : nil
    }
    
    var tracksTabView: some View {
        self.component.tracksTab.view
    }
    var mapView: some View {
        self.component.map.view
    }
    
    var settingsView: some View {
        self.component.settings.view
    }
}
