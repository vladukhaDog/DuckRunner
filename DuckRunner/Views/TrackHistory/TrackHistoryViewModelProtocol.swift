//
//  TrackHistoryViewModelProtocol.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//


import SwiftUI
import Combine

protocol TrackHistoryViewModelProtocol: ObservableObject {
    var tracks: [Track] { get }
    var selectedDate: Date { get set }
}
