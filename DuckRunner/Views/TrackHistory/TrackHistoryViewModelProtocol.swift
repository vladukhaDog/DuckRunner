//
//  TrackHistoryViewModelProtocol.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//

import SwiftUI
import Combine

/// Protocol for view models that provide track history data and date selection for the UI.
protocol TrackHistoryViewModelProtocol: ObservableObject {
    /// The list of tracks to display, typically filtered by the selected date.
    var tracks: [Track] { get }
    /// The date currently selected for viewing track history.
    var selectedDate: Date { get set }
}
