//
//  TrackDetailBuilder.swift
//  Routka
//
//  Created by vladukha on 27.04.2026.
//
import Foundation

/// specific protocol to create all track details inside RootComponent and save ourselves from dependency cycles ie TrackDetailComponent -> TrackDetailComponent
protocol TrackDetailBuilder: AnyObject {
    func trackDetail(_ track: Track) -> TrackDetailComponent
}

final class TrackDetailBuilderImpl: TrackDetailBuilder {
    private let component: RootComponent
    init(component: RootComponent) {
        self.component = component
    }
    func trackDetail(_ track: Track) -> TrackDetailComponent {
        component.trackDetail(track)
    }
}
