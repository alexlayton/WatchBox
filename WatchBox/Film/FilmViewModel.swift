//
//  FilmViewModel.swift
//  WatchBox
//
//  Created by Alex Layton on 04/07/2021.
//

import Foundation
import SwiftUI
import Combine

class FilmViewModel {
    
    // MARK: Propeties
    
    let filmEntity: FilmEntity
    
    let dataStore: WatchBoxStore
    
    @Published var rating: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializers
    
    init(film: FilmEntity, dataStore: WatchBoxStore) {
        self.filmEntity = film
        self.dataStore = dataStore
    }
    
    // MARK: -
    
    func addRating(value: Int) {
        do {
            try self.filmEntity.addRating(value)
        } catch {
            print("Error adding rating - \(error.localizedDescription)")
        }
    }
    
    func delete() {
        do {
            try dataStore.delete(film: filmEntity)
        } catch {
            print("Error deleting film - \(error.localizedDescription)")
        }
    }
    
}
