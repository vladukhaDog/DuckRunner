//
//  TabRouter.swift
//  DuckRunner
//
//  Created by vladukha on 20.02.2026.
//

import Foundation

protocol TabRouterProtocol: AnyObject, Observable{
    var selectedTab: String { get set }
}

@Observable
final class TabRouter: TabRouterProtocol {
    var selectedTab: String = "map"
}
