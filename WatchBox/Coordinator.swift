//
//  Coordinator.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import UIKit

class Coordinator {
    
    // MARK: Properties
    
    let storyboard: UIStoryboard
    
    let navigationController: UINavigationController
    
    let dataStore = WatchBoxStore()
    
    // MARK: Initializers
    init(storyboard: UIStoryboard, navigationController: UINavigationController) {
        self.storyboard = storyboard
        self.navigationController = navigationController
    }
    
    // MARK: -
    
    func start() {
        dataStore.loadPersistentStores { [unowned self] _, error in
            guard error == nil else {
                fatalError("Failed to load persistent store - \(error!.localizedDescription)")
            }
            let _ = try? dataStore.seed()
            self.presentInitialViewController()
        }
    }
    
    func presentInitialViewController() {
        guard let viewController = storyboard.instantiateViewController(identifier: "Favourites") as? FavouritesViewController else {
            fatalError("Failed to instantiate favourites view controller")
        }
        viewController.viewModel = FavouritesViewModel(dataStore: dataStore)
        viewController.searchController = createSearchController()
        viewController.filmHandler = { [unowned self] film in
            self.pushFilmViewController(film: film)
        }
        navigationController.viewControllers = [viewController]
    }
    
    func createSearchController() -> UISearchController {
        guard let viewController = storyboard.instantiateViewController(identifier: SearchViewController.storyboardIdentifier) as? SearchViewController else {
            fatalError("Failed to instantiate search view controller")
        }
        viewController.viewModel = SearchViewModel(dataStore: dataStore)
        viewController.filmHandler = { [unowned self] film in
            self.pushFilmViewController(film: film)
        }
        let searchController = UISearchController(searchResultsController: viewController)
        searchController.searchResultsUpdater = viewController
        return searchController
    }
    
    func pushFilmViewController(film: FilmEntity) {
        guard let viewController = storyboard.instantiateViewController(identifier: FilmViewController.storyboardIdentifier) as? FilmViewController else {
            fatalError("Failed to instantiate film view controller")
        }
        viewController.viewModel = FilmViewModel(film: film)
        navigationController.pushViewController(viewController, animated: true)
    }
}
