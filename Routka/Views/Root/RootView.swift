//
//  RootView.swift
//  Routka
//
//  Created by vladukha on 23.04.2026.
//
import SwiftUI
import vladukhaAlerts

struct RootView: View {
    @State private var vm: RootViewModel
    
    init(vm: RootViewModel) {
        self.vm = vm
    }
    var body: some View {
        TabView(selection: $vm.tabRouter.selectedTab) {
            Tab("Map", systemImage: "map", value: "map") {
                vm.mapView
            }
            if let router = vm.routers["Tracks"] {
                Tab("Tracks", systemImage: "book.pages", value: "Tracks") {
                    NavigatableView(router) {
                        vm.tracksTabView
                    }
                }
                .accessibilityIdentifier("tracksTab")
            }
        }
        .disclaimerOnce()
        .fileManager(trackFileService: vm.fileService,
                     routing: vm.fileServiceWrapperNavigator)
        .alertable(vm.alertController,
                   alignment: .top)
        .preferredColorScheme(vm.preferredColorScheme)
    }
}
