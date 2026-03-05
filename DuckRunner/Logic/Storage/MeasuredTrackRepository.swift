//
//  MeasuredTrackRepository.swift
//  DuckRunner
//
//  Created by vladukha on 04.03.2026.
//
import Foundation
import CoreData
import os
import Combine

final class MeasuredTrackRepository: MeasuredTrackStorageProtocol {
    /// Publishes storage actions (creation, deletion, update) to notify observers of changes.
    var actionPublisher: PassthroughSubject<MeasuredTrackStorageAction, Never> = .init()
    
    /// Sends a storage action event through the publisher.
    internal func sendAction(_ action: MeasuredTrackStorageAction) {
        actionPublisher.send(action)
    }
    
    /// Initializes the repository with a Core Data container.
    init() {
        self.container = publicContainer
    }
    
    /// The NSPersistentContainer managing Core Data storage.
    private var container: NSPersistentContainer
    
    /// Background context for performing storage operations.
    lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = container.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()

    func getMeasuredTracks() async -> [MeasuredTrack] {
        let context = self.backgroundContext
        return await withCheckedContinuation { [context] continuation in
            context.performAndWait {
                
                let request: NSFetchRequest<MeasuredTrackDTO> = MeasuredTrackDTO.fetchRequest()
                
                let measuredTrackDTOs = (try? context.fetch(request)) ?? []
                
                let measuredTracks: [MeasuredTrack] = measuredTrackDTOs
                    .compactMap { dto in
                        let track = MeasuredTrack(dto)
                        guard dto.track != nil else {
                            context.delete(dto)
                            self.sendAction(.deleted(track))
                            return nil
                        }
                        return track
                    }
                if context.hasChanges {
                    do { try context.save() } catch {
                        trackRepositoryLogger.log("Failed deleting orphaned measured tracks", message: error.localizedDescription, .error)
                    }
                }
                
                continuation.resume(returning: measuredTracks)
            }
        }
    }
    
    func addMeasuredTrack(_ track: MeasuredTrack) async {
        let context = self.backgroundContext
        return await withCheckedContinuation { [context] continuation in
            context.performAndWait {
             
                // Creating the record
                let _ = MeasuredTrackDTO(context: context, track)
                if context.hasChanges {
                    try? context.save()
                    self.sendAction(.created(track))
                }
                continuation.resume()
            }
        }
    }
    
    func deleteMeasuredTrack(_ track: MeasuredTrack) async {
        let context = self.backgroundContext
        await withCheckedContinuation { [context, track] continuation in
            context.performAndWait {
                let request = MeasuredTrackDTO.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", track.id)
                do {
                    if let item = try context.fetch(request).first {
                        context.delete(item)
                        if context.hasChanges {
                            try context.save()
                            self.sendAction(.deleted(track))
                        }
                    }
                } catch {
                    trackRepositoryLogger.log("Failed deleting the track", message: error.localizedDescription, .error)
                }
                continuation.resume()
            }
        }
    }
}
