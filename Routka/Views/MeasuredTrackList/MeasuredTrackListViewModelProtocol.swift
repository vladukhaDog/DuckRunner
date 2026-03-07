//
//  MeasuredTrackListViewModelProtocol.swift
//  Routka
//
//  Created by vladukha on 04.03.2026.
//
import SwiftUI

protocol MeasuredTrackListViewModelProtocol: Observable {
    var tracks: [MeasuredTrack] { get }
    func delete(at offsets: IndexSet) async
}
