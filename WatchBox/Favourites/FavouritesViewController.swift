//
//  FavouritesViewController.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import UIKit
import Combine

typealias FavouritesDataSource = UICollectionViewDiffableDataSource<FavouritesViewController.Section, FilmEntity>

class FavouritesViewController: UIViewController {
    
    // MARK: Types
    
    enum Section: CaseIterable {
        case all
    }
    
    typealias FilmHandler = (FilmEntity) -> ()
    
    // MARK: Properties
    
    var viewModel: FavouritesViewModel?
    
    var searchController: UISearchController?
    
    var filmHandler: FilmHandler?
    
    private lazy var dataSource: FavouritesDataSource = createDataSource()
    
    private let cancellables = Set<AnyCancellable>()
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.dataSource = dataSource
        
        configureSearchController()
        configureCollectionView()
        
        viewModel?.fetchFavourites()
    }
    
    // MARK: -
    
    private func configureCollectionView() {
        let layout = collectionView.collectionViewLayout as? FilmsLayout
        layout?.minimumInteritemSpacing = 20.0
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    private func configureSearchController() {
        guard let searchController = searchController else {
            return
        }
        navigationItem.searchController = searchController
    }
    
    private func createDataSource() -> FavouritesDataSource {
        return FavouritesDataSource(collectionView: collectionView) { collectionView, indexPath, filmEntity -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCell.reuseIdentifier, for: indexPath) as? FilmCell else {
                fatalError("Failed to dequeue FilmCell")
            }
            cell.film = filmEntity.film
            return cell
        }
    }

}

// MARK: UICollectionViewDelegate

extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let film = viewModel?.film(at: indexPath) {
            filmHandler?(film)
        }
    }
    
}
