//
//  SearchViewController.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import UIKit
import Combine

final class SearchViewController: UIViewController {
    
    // MARK: Types
    
    enum Section: Int, CaseIterable {
        case omdb
        case favourites
    }
    
    typealias FilmHandler = (FilmEntity) -> ()
    
    // MARK: Properties
    
    static let storyboardIdentifier = "Search"
    
    var viewModel: SearchViewModel?
    
    var filmHandler: FilmHandler?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100.0
        
        configureBindings()
    }
    
    // MARK: -
    
    private func configureBindings() {
        guard let viewModel = viewModel else {
            return
        }
        
        Publishers
            .CombineLatest(viewModel.$omdbResponse, viewModel.$favourites)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    func addFavourite() {
        viewModel?.addResponse()
    }
    
}

// MARK: UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel?.omdbResponse != nil ? 1 : 0
        } else {
            return viewModel?.favourites.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell else {
            fatalError("Failed to dequeue SearchResultsCell")
        }
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .omdb:
            cell.searchResult = viewModel?.omdbResponse
        case .favourites:
            cell.searchResult = viewModel?.favourites[indexPath.row].searchResult
        }
        cell.addHandler = addFavourite
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.title
    }
    
}

// MARK: UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section),
              let film = viewModel?.favourites[indexPath.row],
              section == .favourites else {
            return
        }
        filmHandler?(film)
    }
    
}

// MARK: UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let viewModel = viewModel,
              let searchText = searchController.searchBar.text,
              searchController.isActive else {
            return
        }
        viewModel.searchText = searchText
    }
    
}

// MARK: Section

extension SearchViewController.Section {
    
    var title: String {
        switch self {
        case .omdb:
            return "OMDB"
        case .favourites:
            return "Favourites"
        }
    }
    
}

