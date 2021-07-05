//
//  WatchBoxStore.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import CoreData
import Combine

final class WatchBoxStore: NSPersistentContainer {
    
    convenience init() {
        self.init(name: "WatchBox")
    }
    
    func filmsByTitle(containing text: String) throws -> [FilmEntity] {
        let fetchRequest: NSFetchRequest<FilmEntity> = FilmEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@", text)
        return try self.viewContext.fetch(fetchRequest)
    }
    
    func filmByID(_ id: String) throws -> FilmEntity? {
        let fetchRequest: NSFetchRequest<FilmEntity> = FilmEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", id)
        let results = try viewContext.fetch(fetchRequest)
        return results.first
    }
    
    func addFilm(from response: OMDBResponse) throws {
        let film = FilmEntity(context: viewContext)
        film.imdbID = response.imdbID
        film.title = response.title
        film.plot = response.plot
        film.actors = response.actors
        film.posterURL = response.poster
        film.year = response.year
        film.createdAt = Date()
        film.modifiedAt = Date()
        try viewContext.save()
    }
    
    func delete(film: FilmEntity) throws {
        viewContext.delete(film)
        try viewContext.save()
    }
    
    func deleteAll() throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: FilmEntity.fetchRequest())
        try viewContext.execute(deleteRequest)
        try viewContext.save()
    }
    
}

// MARK: FilmEntity

extension FilmEntity {
    
    func addRating(_ rating: Int) throws {
        self.rating = Int16(rating)
        self.modifiedAt = Date()
        try managedObjectContext?.save()
    }
    
}

