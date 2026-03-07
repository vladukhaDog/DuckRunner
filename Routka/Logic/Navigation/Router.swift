//
//  Router.swift
//  Routka
//
//  Created by vladukha on 24.02.2026.
//

import Foundation
import Combine
import SimpleRouter

/// Class to control navigation
@MainActor
final class Router: RouterProtocol {
    @Published var path: [AnyRoute] = []

    func push<R: Route>(_ route: R) {
        path.append(AnyRoute(route))
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
