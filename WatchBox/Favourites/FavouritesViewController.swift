//
//  FavouritesViewController.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import UIKit
import Combine
import SwiftUI

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
    
    private var emptyView: UIView?
    
    private lazy var dataSource: FavouritesDataSource = createDataSource()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureBindings()
        configureSearchController()
        configureCollectionView()
        
        viewModel?.dataSource = dataSource
        viewModel?.fetchFavourites()
    }
    
    // MARK: -
    
    private func configureViews() {
        let hostingController = UIHostingController(rootView: EmptyView())
        guard let emptyView = hostingController.view else {
            return
        }
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.emptyView = emptyView
    }
    
    private func configureBindings() {
        viewModel?.$isEmpty
            .receive(on: DispatchQueue.main)
            .sink { isEmpty in
                self.emptyView?.isHidden = !isEmpty
            }
            .store(in: &cancellables)
    }
    
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
    
    // MARK: Actions
    
    @IBAction func deleteTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete all", message: "Are you sure you want to delete all films?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel?.deleteAll()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
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
