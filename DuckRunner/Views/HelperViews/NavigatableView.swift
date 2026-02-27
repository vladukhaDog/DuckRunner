//
//  NavigatableView.swift
//  DuckRunner
//
//  Created by vladukha on 24.02.2026.
//

import SwiftUI
import SimpleRouter

/// Wrapper to add NavigationStack, route handlers, adds rotuer as environmentObject
struct NavigatableView<Root: View>: View {
    @ObservedObject private var router: Router
    private let root: Root
    
    init(_ router: Router,
        @ViewBuilder root: () -> Root) {
        self.router = router
        self.root = root()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            root
                .environmentObject(router)
                .navigationDestination(for: AnyRoute.self) { route in
                    route.makeView()
                }
        }
    }
}

#Preview {
    NavigatableView(.init()) {
        Text("aa")
    }
}

