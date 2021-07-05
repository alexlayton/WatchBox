//
//  SearchViewModel.swift
//  WatchBox
//
//  Created by Alex Layton on 02/07/2021.
//

import Foundation
import Combine
import UIKit
import CoreData

final class SearchViewModel {
    
    // MARK: Properties
    
    let provider: OMDBProvider
    
    let dataStore: WatchBoxStore
    
    @Published var omdbResponse: SearchResult?
    
    @Published var favourites = [FilmEntity]()
    
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializers
    
    init(provider: OMDBProvider, dataStore: WatchBoxStore) {
        self.provider = provider
        self.dataStore = dataStore
        configureBindings()
    }
    
    // MARK: Bindings
    
    private func configureBindings() {
        let debouncedSearchText = $searchText
            .debounce(for: 1.0, scheduler: RunLoop.main)
            .share()
        
        // Logging
        debouncedSearchText
            .sink { searchText in
                print(searchText)
            }
            .store(in: &cancellables)
        
        // API Request
        let apiRequest = debouncedSearchText
            .filter { $0 != "" }
            .map { TitleRequest(title: $0) }
            .flatMap { self.provider.titleSearch(request: $0) }
            .map { Optional($0) }
            .catch { error -> Just<OMDBResponse?> in
                print("Error fetching from API - \(error.localizedDescription)")
                return Just(nil)
            }
            .share()
        
        // Check if the OMDB result already exists in the database
        let isAdded = apiRequest
            .compactMap { $0?.imdbID }
            .flatMap { self.dataStore.filmByIDPublisher(id: $0) }
            .catch { error -> Just<FilmEntity?> in
                print("Error fetching from store - \(error.localizedDescription)")
                return Just(nil)
            }
            .map { $0 != nil }
        
        // Create SearchResult from the OMDB result and the database check
        Publishers
            .CombineLatest(apiRequest, isAdded)
            .map { response, isAdded -> SearchResult? in
                guard let response = response else {
                    return nil
                }
                return SearchResult(data: response, isAdded: isAdded, hasDisclosure: false)
            }
            .assign(to: \.omdbResponse, on: self)
            .store(in: &cancellables)
        
        
        // Filter stored favourites
        debouncedSearchText
            .filter { $0 != "" }
            .flatMap { self.dataStore.filmsByTitlePublisher(containing: $0) }
            .catch { error -> Just<[FilmEntity]> in
                print("Error fetching from store - \(error.localizedDescription)")
                return Just([])
            }
            .assign(to: \.favourites, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: -
    
    func addResponse() {
        guard let response = omdbResponse?.data as? OMDBResponse else {
            return
        }
        do {
            try dataStore.addFilm(from: response)
            self.favourites = try dataStore.filmsByTitle(containing: searchText)
            self.omdbResponse = SearchResult(data: response, isAdded: true, hasDisclosure: false)
        } catch {
            print("Error adding film - \(error.localizedDescription)")
        }
    }
    
}


