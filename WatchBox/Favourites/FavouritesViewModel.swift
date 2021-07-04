//
//  FavouritesViewModel.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import UIKit
import Combine
import CoreData

typealias FavouritesSnapshot = NSDiffableDataSourceSnapshot<FavouritesViewController.Section, FilmEntity>

class FavouritesViewModel: NSObject {

    // MARK: Properties
    
    let dataStore: WatchBoxStore
    
    var dataSource: FavouritesDataSource?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<FilmEntity> = createFetchedResultsController()
    
    private var hasLoaded = false
    
    @Published var isEmpty = true
    
    // MARK: Initializers
    
    init(dataStore: WatchBoxStore) {
        self.dataStore = dataStore
    }
    
    // MARK: -
    
    func fetchFavourites() {
        assert(dataSource != nil, "fetchFavourites() called before assigning dataSource")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch films - \(error.localizedDescription)")
        }
    }
    
    func film(at indexPath: IndexPath) -> FilmEntity? {
        return fetchedResultsController.fetchedObjects?[indexPath.row]
    }
    
    func deleteAll() {
        do {
            try dataStore.deleteAll()
            try fetchedResultsController.performFetch()
        } catch {
            print("Error deleting all films - \(error.localizedDescription)")
        }
    }
    
    private func createFetchedResultsController() -> NSFetchedResultsController<FilmEntity> {
        let fetchRequest: NSFetchRequest<FilmEntity> = FilmEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataStore.viewContext, sectionNameKeyPath: nil, cacheName: "favourites")
        controller.delegate = self
        return controller
    }
    
}

extension FavouritesViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dataSource = dataSource else {
            return
        }
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        
        let films = snapshot.itemIdentifiers.compactMap { self.dataStore.viewContext.object(with: $0) as? FilmEntity }
        
        isEmpty = films.count == 0
        
        var favouritesSnapshot = FavouritesSnapshot()
        favouritesSnapshot.appendSections([.all])
        favouritesSnapshot.appendItems(films, toSection: .all)
        dataSource.apply(favouritesSnapshot, animatingDifferences: hasLoaded)
        hasLoaded = true
    }
    
}
