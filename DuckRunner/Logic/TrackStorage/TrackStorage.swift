//
//  TrackStorage.swift
//  DuckRunner
//
//  Created by vladukha on 15.02.2026.
//

import Foundation


protocol TrackStorageProtocol: AnyObject  {
    func fetchTracks() async throws -> [Track]
    func addTrack(_ track: Track) async throws
    func removeTrack(_ track: Track) async throws
}


final class TrackStorage: TrackStorageProtocol {
    func fetchTracks() async throws -> [Track] {
      return []
    }
    
    func addTrack(_ track: Track) async throws {
        
    }
    
    func removeTrack(_ track: Track) async throws {
        
    }
    
    
}
