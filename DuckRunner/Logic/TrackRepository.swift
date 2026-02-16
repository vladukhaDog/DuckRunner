//
//  FavouritesRepository.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//


import Foundation
import CoreData
import os
import Combine

let publicContainer = {
    let container = NSPersistentContainer(name: "CoreDataStorage")
    container.loadPersistentStores { _, error in
        if let error {
            print("Failed loading container", error)
        }
    }
    return container
}()

final class TrackRepository: TrackStorageProtocol {
    var actionPublisher: PassthroughSubject<StorageAction, Never> = .init()
    
    /// send an action that was made with our object
    internal func sendAction(_ action: StorageAction) {
        actionPublisher.send(action)
    }
    
    init() {
        self.container = publicContainer
    }
    
    private var container: NSPersistentContainer
    lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = container.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
    
    func addTrack(_ track: Track) async {
        
        let context = self.backgroundContext
        return await withCheckedContinuation { [context] continuation in
            context.performAndWait {
                let request = TrackDTO.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", track.id)
                request.fetchLimit = 1
                let existingFav = (try? context.fetch(request)) ?? []
                if existingFav.first != nil {
                    // track already exists, so we return it and exit the continuation
                    continuation.resume()
                    return
                }
                
                // Creating the record
                let _ = TrackDTO(context: context, track)
                if context.hasChanges {
                    try? context.save()
                    self.sendAction(.created(track))
                }
                continuation.resume()
            }
        }
    }

    // Prefer deleting by id (Sendable) instead of passing NSManagedObject across actors
    func deleteTrack(_ track: Track) async {
        let context = self.backgroundContext
        await withCheckedContinuation { [context, track] continuation in
            context.performAndWait {
                let request = TrackDTO.fetchRequest()
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
                    print(error)
                }
                continuation.resume()
            }
        }
    }
    
    func updateTrack(_ track: Track) async throws {
        let context = self.backgroundContext
        await withCheckedContinuation { [context, track] continuation in
            context.performAndWait {
                let request = TrackDTO.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", track.id)
                do {
                    if let item = try context.fetch(request).first {
                        item.points = NSSet(array: track.points.map({TrackPointDTO(context: context, $0)}))
                        item.stopDate = track.stopDate
                        item.startDate = track.startDate
                        if context.hasChanges {
                            try context.save()
                            self.sendAction(.updated(track))
                        }
                    }
                } catch {
                    print(error)
                }
                continuation.resume()
            }
        }
    }
    
    func getAllTracks() async -> [Track] {
        let context = self.backgroundContext
        return await withCheckedContinuation { [context] continuation in
            context.performAndWait {
                
                let request = TrackDTO.fetchRequest()
                
                request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
                
                do {
                    let items = try context.fetch(request)
                    let dtos = items.compactMap { Track($0) }
                    continuation.resume(returning: dtos)
                } catch {
                    print(error)
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    func getTracks(for date: Date) async -> [Track] {
        let context = self.backgroundContext
        return await withCheckedContinuation { [context] continuation in
            context.performAndWait {
                
                let request: NSFetchRequest<TrackDTO> = TrackDTO.fetchRequest()
                let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
                request.predicate = NSPredicate(format: "startDate >= %@ && startDate <= %@",
                                                Calendar.current.startOfDay(for: date) as NSDate,
                                                Calendar.current.startOfDay(for: nextDay) as NSDate)
                
                let tracks = (try? context.fetch(request)) ?? []
                continuation.resume(returning: tracks.map({Track($0)}))
            }
        }
    }
}
