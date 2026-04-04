//
//  TrackFileService.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//

import Foundation
import SwiftUI

enum TrackFileServiceError: Error {
    case invalidFile
}

protocol TrackFileServiceProtocol: Observable {
    var isImporterPresented: Bool { get set }
    var isExporterPresented: Bool { get set }
    var fileToExport: URL? { get set }
    @discardableResult
    func importFromFile(url: URL) async throws -> Track
    func exportTrack(_ track: Track)
    func showImporter()
}

@Observable
final class TrackFileService: TrackFileServiceProtocol {
    
    private weak var trackStorage: (any TrackStorageProtocol)?
    
    init(trackStorage: any TrackStorageProtocol) {
        self.trackStorage = trackStorage
    }
    
    var isImporterPresented = false
    var isExporterPresented = false
    var fileToExport: URL?
    
    func showImporter() {
        self.isImporterPresented = true
    }
    
    @discardableResult
    func importFromFile(url: URL) async throws -> Track {
        guard url.pathExtension.lowercased() == "routka" else { throw TrackFileServiceError.invalidFile}
        do {
            let data = try Data(contentsOf: url)
            var track = try JSONDecoder().decode(Track.self, from: data)
            track.trackType = .import // override so it is always considered an import
            try await trackStorage?.addTrack(track)
            return track
        } catch {
            print("Failed to import .routka file: \(error)")
            // TODO: Record error to metric
            throw error
        }
    }
    
    func exportTrack(_ track: Track) {
        if let url = self.exportTrackToFile(track: track) {
            self.isExporterPresented = true
            self.fileToExport = url
        }
    }
    
    func exportTrackToFile(track: Track) -> URL? {
        do {
            let data = try JSONEncoder().encode(track)
            let baseName = sanitizedFileName(for: track)
            let filename = "\(baseName).routka"
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(filename)
            try data.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            print("Failed to export .routka file: \(error)")
            return nil
        }
    }

    private func sanitizedFileName(for track: Track) -> String {
        var customName: String
        if let source = track.custom_name?.trimmingCharacters(in: .whitespacesAndNewlines){
            let invalidCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>:")
            let components = source.components(separatedBy: invalidCharacters)
            let sanitized = components.joined(separator: "_")
                .replacingOccurrences(of: "\n", with: " ")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            customName = sanitized
        } else {
            customName = track.id
        }

        return customName
    }
    
}
